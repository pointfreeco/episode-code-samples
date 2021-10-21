import CasePaths
import SwiftUI

class ItemViewModel: Identifiable, ObservableObject {
  @Published var item: Item

  var id: Item.ID {
    self.item.id
  }

  init(item: Item) {
    self.item = item
  }
}

struct ItemView: View {
  @ObservedObject var viewModel: ItemViewModel
  @State var nameIsDuplicate = false

  var body: some View {
    Form {
      TextField("Name", text: self.$viewModel.item.name)
        .background(self.nameIsDuplicate ? Color.red.opacity(0.1) : Color.clear)
        .onChange(of: self.viewModel.item.name) { newName in
          Task { @MainActor in
            await Task.sleep(NSEC_PER_MSEC * 300)
            self.nameIsDuplicate = newName == "Bluetooth Keyboard"
          }
        }

      Picker(selection: self.$viewModel.item.color, label: Text("Color")) {
        Text("None")
          .tag(Item.Color?.none)

        ForEach(Item.Color.defaults, id: \.name) { color in
          Text(color.name)
            .tag(Optional(color))
        }
      }
      
      IfCaseLet(self.$viewModel.item.status, pattern: /Item.Status.inStock) { $quantity in
        Section(header: Text("In stock")) {
          Stepper("Quantity: \(quantity)", value: $quantity)
          Button("Mark as sold out") {
            self.viewModel.item.status = .outOfStock(isOnBackOrder: false)
          }
        }
      }
      IfCaseLet(self.$viewModel.item.status, pattern: /Item.Status.outOfStock) { $isOnBackOrder in
        Section(header: Text("Out of stock")) {
          Toggle("Is on back order?", isOn: $isOnBackOrder)
          Button("Is back in stock!") {
            self.viewModel.item.status = .inStock(quantity: 1)
          }
        }
      }
    }
  }
}

struct ColorPickerView: View {
  @State var newColors: [Item.Color] = []
  @Binding var color: Item.Color?
  @Environment(\.dismiss) var dismiss

  var body: some View {
    Form {
      Button(action: {
        self.color = nil
        self.dismiss()
      }) {
        HStack {
          Text("None")
          Spacer()
          if self.color == nil {
            Image(systemName: "checkmark")
          }
        }
      }

      Section(header: Text("Default colors")) {
        ForEach(Item.Color.defaults, id: \.name) { color in
          Button(action: {
            self.color = color
            self.dismiss()
          }) {
            HStack {
              Text(color.name)
              Spacer()
              if self.color == color {
                Image(systemName: "checkmark")
              }
            }
          }
        }
      }

      if !self.newColors.isEmpty {
        Section(header: Text("New colors")) {
          ForEach(self.newColors, id: \.name) { color in
            Button(action: {
              self.color = color
              self.dismiss()
            }) {
              HStack {
                Text(color.name)
                Spacer()
                if self.color == color {
                  Image(systemName: "checkmark")
                }
              }
            }
          }
        }
      }
    }
    .task {
      try? await Task.sleep(nanoseconds: NSEC_PER_SEC)
      self.newColors = [
        .init(name: "Pink", red: 1, green: 0.7, blue: 0.7)
      ]
    }
  }
}

struct ItemView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ItemView(viewModel: .init(item: .init(name: "", color: nil, status: .inStock(quantity: 1))))
    }
  }
}
