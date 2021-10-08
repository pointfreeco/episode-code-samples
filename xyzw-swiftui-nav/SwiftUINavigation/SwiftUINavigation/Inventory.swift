import IdentifiedCollections
import SwiftUI

struct Item: Equatable, Identifiable {
  let id = UUID()
  var name: String
  var color: Color?
  var status: Status

  enum Status: Equatable {
    case inStock(quantity: Int)
    case outOfStock(isOnBackOrder: Bool)

    var isInStock: Bool {
      guard case .inStock = self else { return false }
      return true
    }
  }

  struct Color: Equatable, Hashable {
    var name: String
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0

    static var defaults: [Self] = [
      .red,
      .green,
      .blue,
      .black,
      .yellow,
      .white,
    ]

    static let red = Self(name: "Red", red: 1)
    static let green = Self(name: "Green", green: 1)
    static let blue = Self(name: "Blue", blue: 1)
    static let black = Self(name: "Black")
    static let yellow = Self(name: "Yellow", red: 1, green: 1)
    static let white = Self(name: "White", red: 1, green: 1, blue: 1)

    var swiftUIColor: SwiftUI.Color {
      .init(red: self.red, green: self.green, blue: self.blue)
    }
  }
}

class InventoryViewModel: ObservableObject {
  @Published var inventory: IdentifiedArrayOf<ItemRowViewModel>
  @Published var itemToAdd: Item?

  init(
    inventory: IdentifiedArrayOf<ItemRowViewModel> = [],
    itemToAdd: Item? = nil
  ) {
    self.itemToAdd = itemToAdd
    self.inventory = []

    for itemRowViewModel in inventory {
      self.bind(itemRowViewModel: itemRowViewModel)
    }
  }

  private func bind(itemRowViewModel: ItemRowViewModel) {
    itemRowViewModel.onDelete = { [weak self, item = itemRowViewModel.item] in
      withAnimation {
        self?.delete(item: item)
      }
    }
    itemRowViewModel.onDuplicate = { [weak self] item in
      withAnimation {
        self?.add(item: item)
      }
    }
    self.inventory.append(itemRowViewModel)
  }

  func delete(item: Item) {
    withAnimation {
      _ = self.inventory.remove(id: item.id)
    }
  }

  func add(item: Item) {
    withAnimation {
      self.bind(itemRowViewModel: .init(item: item))
      self.itemToAdd = nil
    }
  }

  func addButtonTapped() {
    self.itemToAdd = .init(name: "", color: nil, status: .inStock(quantity: 1))

    Task { @MainActor in
      try await Task.sleep(nanoseconds: 500 * NSEC_PER_MSEC)
      self.itemToAdd?.name = "Bluetooth Keyboard"
    }
  }

  func cancelButtonTapped() {
    self.itemToAdd = nil
  }
}

struct InventoryView: View {
  @ObservedObject var viewModel: InventoryViewModel
  
  var body: some View {
    List {
      ForEach(
        self.viewModel.inventory,
        content: ItemRowView.init(viewModel:)
      )
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button("Add") { self.viewModel.addButtonTapped() }
      }
    }
    .navigationTitle("Inventory")
    .sheet(unwrap: self.$viewModel.itemToAdd) { $itemToAdd in
      NavigationView {
        ItemView(item: $itemToAdd)
          .navigationTitle("Add")
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") { self.viewModel.cancelButtonTapped() }
            }
            ToolbarItem(placement: .primaryAction) {
              Button("Save") { self.viewModel.add(item: itemToAdd) }
            }
          }
      }
    }
  }
}

struct TestView: View {
  @State var collection = [1, 2, 3]

  var body: some View {
    ForEach(self.$collection, id: \.self) { $element in

    }
  }
}

struct InventoryView_Previews: PreviewProvider {
  static var previews: some View {
    let keyboard = Item(name: "Keyboard", color: .blue, status: .inStock(quantity: 100))
    
    NavigationView {
      InventoryView(
        viewModel: .init(
          inventory: [
            .init(item: keyboard),
            .init(item: Item(name: "Charger", color: .yellow, status: .inStock(quantity: 20))),
            .init(item: Item(name: "Phone", color: .green, status: .outOfStock(isOnBackOrder: true))),
            .init(item: Item(name: "Headphones", color: .green, status: .outOfStock(isOnBackOrder: false))),
          ],
          itemToAdd: nil
        )
      )
    }
  }
}
