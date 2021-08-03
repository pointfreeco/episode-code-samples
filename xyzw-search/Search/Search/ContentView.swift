import MapKit
import SwiftUI

struct ContentView: View {
  var body: some View {
    Map(
      coordinateRegion: .constant(
        .init(
          center: .init(latitude: 40.7, longitude: -74),
          span: .init(latitudeDelta: 0.075, longitudeDelta: 0.075)
        )
      )
//      interactionModes: <#T##MapInteractionModes#>,
//      showsUserLocation: <#T##Bool#>,
//      userTrackingMode: <#T##Binding<MapUserTrackingMode>?#>,
//      annotationItems: <#T##RandomAccessCollection#>,
//      annotationContent: <#T##(Identifiable) -> MapAnnotationProtocol#>
    )
      .searchable(
        text: .constant("")
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ContentView()
    }
  }
}
