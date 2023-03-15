import SwiftUI
import XCTestDynamicOverlay

class AppModel: ObservableObject {
  @Published var firstTab: FirstTabModel {
    didSet { self.bind() }
  }
  @Published var selectedTab: Tab

  init(
    firstTab: FirstTabModel,
    selectedTab: Tab = .one
  ) {
    self.firstTab = firstTab
    self.selectedTab = selectedTab
    self.bind()
  }

  private func bind() {
    self.firstTab.switchToInventoryTab = { [weak self] in
      self?.selectedTab = .inventory
    }
  }
}

class FirstTabModel: ObservableObject {
  var switchToInventoryTab: () -> Void = unimplemented("FirstTabModel.switchToInventoryTab")

  func goToInventoryTab() {
    self.switchToInventoryTab()
  }
}
