import ItemRowFeature
import ParsingHelpers
import SwiftUI

@main
struct ItemRowPreviewAppApp: App {
  let viewModel = ItemRowViewModel(item: .init(name: "Keyboard", color: .blue, status: .inStock(quantity: 1)))
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        List {
          ItemRowView(
            viewModel: self.viewModel
          )
        }
      }
      .onOpenURL { url in
        var request = DeepLinkRequest(url: url)
        if let route = itemRowDeepLinker.parse(&request) {
          self.viewModel.navigate(to: route)
        }
      }
    }
  }
}
