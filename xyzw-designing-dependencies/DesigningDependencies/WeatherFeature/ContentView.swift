import Combine
import CoreLocation
import SwiftUI
import Network
import PathMonitorClient
import WeatherClient

public struct LocationClient {
  var authorizationStatus: () -> CLAuthorizationStatus
  var requestWhenInUseAuthorization: () -> Void
  var requestLocation: () -> Void
//  var setDelegate: (CLLocationManagerDelegate) -> Void
  
//  var didChangeAuthorization: AnyPublisher<CLAuthorizationStatus, Never>
//  var didUpdateLocations: AnyPublisher<[CLLocation], Never>
//  var didFailWithError: AnyPublisher<Error, Never>
  var delegate: AnyPublisher<DelegateEvent, Never>
  
  enum DelegateEvent {
    case didChangeAuthorization(CLAuthorizationStatus)
    case didUpdateLocations([CLLocation])
    case didFailWithError(Error)
  }
}

extension LocationClient {
  static var live: Self {
    class Delegate: NSObject, CLLocationManagerDelegate {
      let subject: PassthroughSubject<DelegateEvent, Never>
      
      init(subject: PassthroughSubject<DelegateEvent, Never>) {
        self.subject = subject
      }
      
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.subject.send(.didChangeAuthorization(status))
      }
      
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.subject.send(.didUpdateLocations(locations))
      }
      
      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.subject.send(.didFailWithError(error))
      }
    }
    
    let locationManager = CLLocationManager()
    let subject = PassthroughSubject<DelegateEvent, Never>()
    var delegate: Delegate? = Delegate(subject: subject)
    locationManager.delegate = delegate
    
    return Self(
      authorizationStatus: CLLocationManager.authorizationStatus,
      requestWhenInUseAuthorization: locationManager.requestWhenInUseAuthorization,
      requestLocation: locationManager.requestLocation,
      delegate: subject
        .handleEvents(receiveCancel: { delegate = nil })
        .eraseToAnyPublisher()
    )
  }
}

extension LocationClient {
  static var authorizedWhenInUse: Self {
    let subject = PassthroughSubject<DelegateEvent, Never>()

    return Self(
      authorizationStatus: { .authorizedWhenInUse },
      requestWhenInUseAuthorization: { },
      requestLocation: {
        subject.send(.didUpdateLocations([CLLocation()]))
      },
      delegate: subject.eraseToAnyPublisher()
    )
  }

  static var notDetermined: Self {
    var status = CLAuthorizationStatus.notDetermined
    let subject = PassthroughSubject<DelegateEvent, Never>()

    return Self(
      authorizationStatus: { status },
      requestWhenInUseAuthorization: {
        status = .authorizedWhenInUse
        subject.send(.didChangeAuthorization(status))
      },
      requestLocation: {
        subject.send(.didUpdateLocations([CLLocation()]))
      },
      delegate: subject.eraseToAnyPublisher()
    )
  }
}

public class AppViewModel: ObservableObject {
  @Published var currentLocation: Location?
  @Published var isConnected = true
  @Published var weatherResults: [WeatherResponse.ConsolidatedWeather] = []

  var weatherRequestCancellable: AnyCancellable?
  var pathUpdateCancellable: AnyCancellable?
  var searchLocationsCancellable: AnyCancellable?
  var locationDelegateCancellable: AnyCancellable?

  let weatherClient: WeatherClient
  let pathMonitorClient: PathMonitorClient
  let locationClient: LocationClient

  public init(
//    isConnected: Bool = true,
    locationClient: LocationClient,
    pathMonitorClient: PathMonitorClient,
    weatherClient: WeatherClient
  ) {
    self.weatherClient = weatherClient
    self.locationClient = locationClient
    self.pathMonitorClient = pathMonitorClient

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

    //delegate

    self.locationDelegateCancellable = self.locationClient.delegate
      .sink { event in
        switch event {
        case let .didChangeAuthorization(status):
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
            self.locationClient.requestLocation()

          @unknown default:
            break
          }

        case let .didUpdateLocations(locations):
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

        case .didFailWithError:
          break
        }
      }

    if self.locationClient.authorizationStatus() == .authorizedWhenInUse {
      self.locationClient.requestLocation()
    }
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
    NavigationView {
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
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    return ContentView(
      viewModel: AppViewModel(
//        isConnected: false,
        locationClient: .notDetermined, // .notDeterminedDenied
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
