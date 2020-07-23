import Combine
import CoreLocation
import SwiftUI
import Network
import PathMonitorClient
import WeatherClient

public class AppViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
  @Published var currentLocation: Location?
  @Published var isConnected = true
  @Published var weatherResults: [WeatherResponse.ConsolidatedWeather] = []

  var weatherRequestCancellable: AnyCancellable?
  var pathUpdateCancellable: AnyCancellable?
  var searchLocationsCancellable: AnyCancellable?

  let weatherClient: WeatherClient
  let pathMonitorClient: PathMonitorClient
  let locationManager = CLLocationManager()

  public init(
//    isConnected: Bool = true,
    pathMonitorClient: PathMonitorClient,
    weatherClient: WeatherClient
  ) {
    self.weatherClient = weatherClient
    
//    let pathMonitor = NWPathMonitor()
//    self.isConnected = isConnected
    self.pathMonitorClient = pathMonitorClient

    super.init()

//    self.pathMonitorClient.setPathUpdateHandler { [weak self] path in
    self.pathUpdateCancellable = self.pathMonitorClient.networkPathPublisher
      .map { $0.status == .satisfied }
      .removeDuplicates()
      .sink(receiveValue: { [weak self] isConnected in
        guard let self = self else { return }
        self.isConnected = isConnected
        if self.isConnected {
          self.refreshWeather()
        } else {
          self.weatherResults = []
        }
      })
//    self.pathMonitorClient.start(.main)

//    self.refreshWeather()

    self.locationManager.delegate = self
  }

//  deinit {
//    self.pathMonitorClient.cancel()
//  }
  
  func refreshWeather() {
    guard let location = self.currentLocation else { return }

    self.weatherResults = []
    
    self.weatherRequestCancellable = self.weatherClient
      .weather(location.woeid)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [weak self] response in
          self?.weatherResults = response.consolidatedWeather
      })
  }

  func locationButtonTapped() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      self.locationManager.requestWhenInUseAuthorization()

    case .restricted:
      // TODO: show an alert
      break
    case .denied:
      // TODO: show an alert
      break

    case .authorizedAlways, .authorizedWhenInUse:
      self.locationManager.requestLocation()

    @unknown default:
      break
    }
  }

  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      break

    case .restricted:
      // TODO: show an alert
      break
    case .denied:
      // TODO: show an alert
      break

    case .authorizedAlways, .authorizedWhenInUse:
      self.locationManager.requestLocation()

    @unknown default:
      break
    }
  }

  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    guard let location = locations.first else { return }

    self.searchLocationsCancellable =  self.weatherClient
      .searchLocations(location.coordinate)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [weak self] locations in
          self?.currentLocation = locations.first
          self?.refreshWeather()
        }
      )
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
  }
}

public struct ContentView: View {
  @ObservedObject var viewModel: AppViewModel

  public init(viewModel: AppViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {
    NavigationView {
      ZStack(alignment: .bottom) {
        ZStack(alignment: .bottomTrailing) {
          List {
            ForEach(self.viewModel.weatherResults, id: \.id) { weather in
              VStack(alignment: .leading) {
                Text(dayOfWeekFormatter.string(from: weather.applicableDate).capitalized)
                  .font(.title)

                Text("Current temp: \(weather.theTemp, specifier: "%.1f")°C")
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
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    return ContentView(
      viewModel: AppViewModel(
//        isConnected: false,
        pathMonitorClient: .flakey,
        weatherClient: {
          var client = WeatherClient.happyPath
          client.searchLocations = { _ in
            Fail(error: NSError(domain: "", code: 1))
              .eraseToAnyPublisher()
          }
          return client
      }()
      )
    )
  }
}

let dayOfWeekFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "EEEE"
  return formatter
}()
