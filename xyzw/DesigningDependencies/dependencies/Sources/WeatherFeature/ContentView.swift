import Combine
import CoreLocation
import SwiftUI
import Network
import PathMonitorClient
import WeatherClient
import LocationClient

struct AsyncRemoveDuplicatesSequence<Base>: AsyncSequence
where
  Base: AsyncSequence,
  Base.Element: Equatable
{
  typealias Element = Base.Element

  let base: Base

  __consuming func makeAsyncIterator() -> AsyncIterator {
    .init(base: self.base.makeAsyncIterator())
  }

  struct AsyncIterator: AsyncIteratorProtocol {
    var base: Base.AsyncIterator
    var previous: Base.Element?

    init(base: Base.AsyncIterator) {
      self.base = base
    }

    mutating func next() async rethrows -> Base.Element? {
      while let element = try await self.base.next() {
        guard element != self.previous
        else { continue }
        defer { self.previous = element }
        return element
      }
      return nil
    }
  }
}

extension AsyncSequence where Element: Equatable {
  func removeDuplicates() -> AsyncRemoveDuplicatesSequence<Self> {
    .init(base: self)
  }
}

public class AppViewModel: ObservableObject {
  @Published var currentLocation: Location?
  @Published var isConnected = true
  @Published var weatherResults: [WeatherResponse.ConsolidatedWeather] = []

  let weatherClient: WeatherClient
  let pathMonitorClient: PathMonitorClient
  let locationClient: LocationClient

  public init(
    locationClient: LocationClient,
    pathMonitorClient: PathMonitorClient,
    weatherClient: WeatherClient
  ) {
    self.weatherClient = weatherClient
    self.locationClient = locationClient
    self.pathMonitorClient = pathMonitorClient
  }

  public func task() async {
    await withTaskGroup(of: Void.self) { group in
      group.addTask { @MainActor in
        let isSatisfiedUpdates = self.pathMonitorClient.networkPathUpdates
          .map { $0.status == .satisfied }
          .removeDuplicates()

        for await isSatisfied in isSatisfiedUpdates {
          self.isConnected = isSatisfied
          if self.isConnected {
            try? await self.refreshWeather()
          } else {
            self.weatherResults = []
          }
        }
      }

      group.addTask { @MainActor in
        for await event in self.locationClient.delegate {
          switch event {
          case let .didChangeAuthorization(status):
            switch status {
            case .notDetermined:
              break
            case .restricted:
              break
            case .denied:
              break
            case .authorizedAlways, .authorizedWhenInUse:
              self.locationClient.requestLocation()
            @unknown default:
              break
            }

          case let .didUpdateLocations(locations):
            guard self.isConnected, let location = locations.first else { return }

            // TODO: Error handling
            self.currentLocation = try? await self.weatherClient
              .searchLocations(location.coordinate)
              .first
            try? await self.refreshWeather()

          case .didFailWithError:
            break
          }
        }
      }

      if self.locationClient.authorizationStatus() == .authorizedWhenInUse {
        self.locationClient.requestLocation()
      }
    }
  }

  // TODO: View model main actor instead?
  @MainActor func refreshWeather() async throws {
    guard let location = self.currentLocation else { return }

    self.weatherResults = []

    self.weatherResults = try await self.weatherClient
      .weather(location.woeid)
      .consolidatedWeather
  }

  func locationButtonTapped() {
    switch self.locationClient.authorizationStatus() {
    case .notDetermined:
      self.locationClient.requestWhenInUseAuthorization()

    case .restricted:
      // TODO: show an alert
      break
    case .denied:
      // TODO: show an alert
      break

    case .authorizedAlways, .authorizedWhenInUse:
      self.locationClient.requestLocation()

    @unknown default:
      break
    }
  }
}

public struct ContentView: View {
  @ObservedObject var viewModel: AppViewModel

  public init(viewModel: AppViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {
    ZStack(alignment: .bottom) {
      ZStack(alignment: .bottomTrailing) {
        List {
          ForEach(self.viewModel.weatherResults, id: \.id) { weather in
            VStack(alignment: .leading) {
              Text(dayOfWeekFormatter.string(from: weather.applicableDate).capitalized)
                .font(.title)

              Text("Current temp: \(weather.theTemp, specifier: "%.1f")°C")
                .bold()
              Text("Max temp: \(weather.maxTemp, specifier: "%.1f")°C")
              Text("Min temp: \(weather.minTemp, specifier: "%.1f")°C")
            }
          }
        }

        Button(
          action: { self.viewModel.locationButtonTapped() }
        ) {
          Image(systemName: "location.fill")
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
        }
        .background(Color.black)
        .clipShape(Circle())
        .padding()
      }

      if !self.viewModel.isConnected {
        HStack {
          Image(systemName: "exclamationmark.octagon.fill")

          Text("Not connected to internet")
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.red)
      }
    }
    .navigationBarTitle(self.viewModel.currentLocation?.title ?? "Weather")
    .task {
      await self.viewModel.task()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      viewModel: AppViewModel(
        locationClient: .notDetermined,
        pathMonitorClient: .satisfied,
        weatherClient: .happyPath
      )
    )
  }
}

let dayOfWeekFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "EEEE"
  return formatter
}()
