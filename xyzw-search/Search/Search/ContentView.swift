import ComposableArchitecture
import MapKit
import SwiftUI

struct CoordinateRegion: Equatable {
  var center = LocationCoordinate2D()
  var span = CoordinateSpan()
}

extension CoordinateRegion {
  init(rawValue: MKCoordinateRegion) {
    self.init(
      center: .init(rawValue: rawValue.center),
      span: .init(rawValue: rawValue.span)
    )
  }

  var rawValue: MKCoordinateRegion {
    .init(center: self.center.rawValue, span: self.span.rawValue)
  }
}

struct LocationCoordinate2D: Equatable {
  var latitude: CLLocationDegrees = 0
  var longitude: CLLocationDegrees = 0
}

extension LocationCoordinate2D {
  init(rawValue: CLLocationCoordinate2D) {
    self.init(latitude: rawValue.latitude, longitude: rawValue.longitude)
  }

  var rawValue: CLLocationCoordinate2D {
    .init(latitude: self.latitude, longitude: self.longitude)
  }
}

struct CoordinateSpan: Equatable {
  var latitudeDelta: CLLocationDegrees = 0
  var longitudeDelta: CLLocationDegrees = 0
}

extension CoordinateSpan {
  init(rawValue: MKCoordinateSpan) {
    self.init(latitudeDelta: rawValue.latitudeDelta, longitudeDelta: rawValue.longitudeDelta)
  }

  var rawValue: MKCoordinateSpan {
    .init(latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta)
  }
}


struct AppState: Equatable {
  var completions: [MKLocalSearchCompletion] = []
  var mapItems: [MKMapItem] = []
  var query = ""
  var region = CoordinateRegion(
    center: .init(latitude: 40.7, longitude: -74),
    span: .init(latitudeDelta: 0.075, longitudeDelta: 0.075)
  )
}

enum AppAction {
  case completionsUpdated(Result<[MKLocalSearchCompletion], Error>)
  case onAppear
  case queryChanged(String)
  case regionChanged(CoordinateRegion)
  case searchResponse(Result<MKLocalSearch.Response, Error>)
  case tappedCompletion(MKLocalSearchCompletion)
}

struct AppEnvironment {
  var localSearch: LocalSearchClient
  var localSearchCompleter: LocalSearchCompleter
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let appReducer = Reducer<
  AppState,
  AppAction,
  AppEnvironment
> { state, action, environment in
  switch action {
  case let .completionsUpdated(.success(completions)):
    state.completions = completions
    return .none
    
  case let .completionsUpdated(.failure(error)):
    // TODO: error handling
    return .none
  
  case .onAppear:
    return environment.localSearchCompleter.completions()
      .map(AppAction.completionsUpdated)
    
  case let .queryChanged(query):
    state.query = query
    return environment.localSearchCompleter.search(query)
      .fireAndForget()

  case let .regionChanged(region):
    state.region = region
    return .none

  case let .searchResponse(.success(response)):
    state.region = .init(rawValue: response.boundingRegion)
    state.mapItems = response.mapItems
    return .none
    
  case let .searchResponse(.failure(error)):
    // TODO: error handling
    return .none
    
  case let .tappedCompletion(completion):
    return environment.localSearch.search(completion)
      .receive(on: environment.mainQueue.animation())
      .catchToEffect()
      .map(AppAction.searchResponse)
  }
}

extension MKLocalSearchCompletion {
  var id: [String] { [self.title, self.subtitle] }
}

extension MKMapItem: Identifiable {}

struct ContentView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      Map(
        coordinateRegion: viewStore.binding(
          get: \.region.rawValue,
          send: { .regionChanged(.init(rawValue: $0)) }
        ),
        //      interactionModes: <#T##MapInteractionModes#>,
        //      showsUserLocation: <#T##Bool#>,
        //      userTrackingMode: <#T##Binding<MapUserTrackingMode>?#>,
        annotationItems: viewStore.mapItems,
        annotationContent: { mapItem in
          MapMarker(coordinate: mapItem.placemark.coordinate)
        }
      )
        .searchable(
          text: viewStore.binding(
            get: \.query,
            send: AppAction.queryChanged
          )
          //        placement: <#T##SearchFieldPlacement#>,
          //        prompt: <#T##LocalizedStringKey#>,
          //        suggestions: <#T##() -> View#>
        ) {
          if viewStore.query.isEmpty {
            HStack {
              Text("Recent Searches")
              Spacer()
              Button(action: {}) {
                Text("See all")
              }
            }
            .font(.callout)

            HStack {
              Image(systemName: "magnifyingglass")
              Text("Apple • New York")
              Spacer()
            }
            HStack {
              Image(systemName: "magnifyingglass")
              Text("Apple • New York")
              Spacer()
            }
            HStack {
              Image(systemName: "magnifyingglass")
              Text("Apple • New York")
              Spacer()
            }

            HStack {
              Text("Find nearby")
              Spacer()
              Button(action: {}) {
                Text("See all")
              }
            }
            .padding(.top)
            .font(.callout)

            ScrollView(.horizontal) {
              HStack {
                ForEach(1...2, id: \.self) { _ in
                  VStack {
                    ForEach(1...2, id: \.self) { _ in
                      HStack {
                        Image(systemName: "bag.circle.fill")
                          .foregroundStyle(Color.white, Color.red)
                          .font(.title)
                        Text("Shopping")
                      }
                      .padding([.top, .bottom, .trailing],  4)
                    }
                  }
                }
              }
            }

            HStack {
              Text("Editors’ picks")
              Spacer()
              Button(action: {}) {
                Text("See all")
              }
            }
            .padding(.top)
            .font(.callout)
          } else {
            ForEach(viewStore.completions, id: \.id) { completion in
              Button(action: { viewStore.send(.tappedCompletion(completion)) }) {
                VStack(alignment: .leading) {
                  Text(completion.title)
                  Text(completion.subtitle)
                    .font(.caption)
                }
              }
            }
          }
        }
        .navigationTitle("Places")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
          viewStore.send(.onAppear)
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ContentView(
        store: .init(
          initialState: .init(),
          reducer: appReducer,
          environment: .init(
            localSearch: .live,
            localSearchCompleter: .live,
            mainQueue: .main
          )
        )
      )
    }
  }
}
