import ParserHelpers
import ItemRowFeature
import SwiftUI

@main
struct ItemRowPreviewAppApp: App {
  let viewModel = ItemRowViewModel(
    item: .init(name: "Keyboard", status: .inStock(quantity: 1))
  )

  var body: some Scene {
    WindowGroup {
      NavigationView {
        List {
          ItemRowView(viewModel: viewModel)
        }
      }
      .onOpenURL {
        var request = DeepLinkRequest(url: $0)
        if let route = itemRowDeepLinker.parse(&request) {
          self.viewModel.navigate(to: route)
        }
      }
    }
  }
}

/*







         
                                 |-------|
                                 |   U   |
                 |-------|       |   s   |
                 |   I   |       |   e   |-------|
         |-------|   n   |       |   r   |   S   |
         |   I   |   v   |-------|   P   |   e   |
         |   t   |   e   |   S   |   r   |   t   |
 |-------|   e   |   n   |   e   |   o   |   t   |
 |   I   |   m   |   t   |   a   |   f   |   i   |    ....
 |   t   |   R   |   o   |   r   |   i   |   n   |
 |   e   |   o   |   r   |   c   |   l   |   g   |
 |   m   |   w   |   y   |   h   |   e   |   s   |
 |-------|-------|-------|-------|-------|-------|
 |----------------------------------------------------------------------------------|
 |                                                                                  |
 |                            MODEL/HELPER/DEPENDENCY MODULES                       |
 |  |---------------|----------------|---------------|-----------|---------------|  |
 |  |    Models     | SwiftUIHelpers | ParserHelpers | ApiClient | ApiClientLive |  |
 |  |---------------|----------------|---------------|-----------|---------------|  |
 |                                                                                  |
 |----------------------------------------------------------------------------------|









 */
