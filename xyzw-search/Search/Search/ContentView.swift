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
  var query = ""
  var region = CoordinateRegion(
    center: .init(latitude: 40.7, longitude: -74),
    span: .init(latitudeDelta: 0.075, longitudeDelta: 0.075)
  )
}

enum AppAction {
  case queryChanged(String)
  case regionChanged(CoordinateRegion)
}

struct AppEnvironment {
}

let appReducer = Reducer<
  AppState,
  AppAction,
  AppEnvironment
> { state, action, environment in
  switch action {
  case let .queryChanged(query):
    state.query = query
    return .none

  case let .regionChanged(region):
    state.region = region
    return .none
  }
}

struct ContentView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      Map(
        coordinateRegion: viewStore.binding(
          get: \.region.rawValue,
          send: { .regionChanged(.init(rawValue: $0)) }
        )
        //      interactionModes: <#T##MapInteractionModes#>,
        //      showsUserLocation: <#T##Bool#>,
        //      userTrackingMode: <#T##Binding<MapUserTrackingMode>?#>,
        //      annotationItems: <#T##RandomAccessCollection#>,
        //      annotationContent: <#T##(Identifiable) -> MapAnnotationProtocol#>
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
          Text("Apple Store")
          Text("Cafe")
          Text("Library")
        }
        .navigationTitle("Places")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom)
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
          environment: .init()
        )
      )
    }
  }
}
