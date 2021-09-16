import SwiftUI

struct ItemView: View {
  @State var item = Item(name: "", color: nil, status: .inStock(quantity: 1))

  var body: some View {
    Form {
      TextField("Name", text: self.$item.name)

      Picker(selection: self.$item.color, label: Text("Color")) {
        Text("None")
          .tag(Item.Color?.none)

        ForEach(Item.Color.defaults, id: \.name) { color in
          Text(color.name)
            .tag(Optional(color))
        }
      }

      switch self.item.status {
      case let .inStock(quantity: quantity):
        Section(header: Text("In stock")) {
          Stepper(
            "Quantity: \(quantity)",
            value: .init(
              get: { quantity },
              set: { self.item.status = .inStock(quantity: $0) }
            )
          )
          Button("Mark as sold out") {
            self.item.status = .outOfStock(isOnBackOrder: false)
          }
        }

      case let .outOfStock(isOnBackOrder: isOnBackOrder):
        Section(header: Text("Out of stock")) {
          Toggle(
            "Is on back order?",
            isOn: .init(
              get: { isOnBackOrder },
              set: { self.item.status = .outOfStock(isOnBackOrder: $0) }
            )
          )
          Button("Is back in stock!") {
            self.item.status = .inStock(quantity: 1)
          }
        }
      }
    }
  }
}

struct ItemView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ItemView()
    }
  }
}
