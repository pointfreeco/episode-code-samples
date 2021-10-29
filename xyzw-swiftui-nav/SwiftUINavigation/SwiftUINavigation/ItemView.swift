import CasePaths
import SwiftUI

struct ColorPickerView: View {
  @Binding var color: Item.Color?
  @State var newColors: [Item.Color] = []
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
      await Task.sleep(NSEC_PER_MSEC * 500)
      self.newColors = [
        .init(name: "Pink", red: 1, green: 0.7, blue: 0.7),
      ]
    }
  }
}

struct ItemView: View {
  @Binding var item: Item
  @State var nameIsDuplicate = false

  var body: some View {
    Form {
      TextField("Name", text: self.$item.name)
        .background(self.nameIsDuplicate ? Color.red.opacity(0.1) : Color.clear)
        .onChange(of: self.item.name) { newName in
          // TODO: Validation logic
          Task { @MainActor in
            await Task.sleep(NSEC_PER_MSEC * 300)
            self.nameIsDuplicate = newName == "Keyboard"
          }
        }

//      Picker(selection: self.$item.color, label: Text("Color")) {
//        Text("None")
//          .tag(Item.Color?.none)
//
//        ForEach(Item.Color.defaults, id: \.name) { color in
//          Text(color.name)
//            .tag(Optional(color))
//        }
//      }
      NavigationLink(
        destination: ColorPickerView(color: self.$item.color)
      ) {
        HStack {
          Text("Color")
          Spacer()
          if let color = self.item.color {
            Rectangle()
              .frame(width: 30, height: 30)
              .foregroundColor(color.swiftUIColor)
              .border(Color.black, width: 1)
          }
          Text(self.item.color?.name ?? "None")
            .foregroundColor(.gray)
        }
      }
      
      IfCaseLet(self.$item.status, pattern: /Item.Status.inStock) { $quantity in
        Section(header: Text("In stock")) {
          Stepper("Quantity: \(quantity)", value: $quantity)
          Button("Mark as sold out") {
            self.item.status = .outOfStock(isOnBackOrder: false)
          }
        }
      }
      IfCaseLet(self.$item.status, pattern: /Item.Status.outOfStock) { $isOnBackOrder in
        Section(header: Text("Out of stock")) {
          Toggle("Is on back order?", isOn: $isOnBackOrder)
          Button("Is back in stock!") {
            self.item.status = .inStock(quantity: 1)
          }
        }
      }
    }
  }
}

struct ItemView_Previews: PreviewProvider {
  struct WrapperView: View {
    @State var item = Item(name: "", color: nil, status: .inStock(quantity: 1))
    
    var body: some View {
      ItemView(item: self.$item)
    }
  }
  
  static var previews: some View {
    NavigationView {
      WrapperView()
    }
  }
}
