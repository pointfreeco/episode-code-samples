import SwiftUI

struct Item {
  var name: String
  var color: Color?
//  var quantity = 1
//  var isInStock = true
//  var isOnBackOrder = false
  var status: Status
  
  enum Status {
    case inStock(quantity: Int)
    case outOfStock(isOnBackOrder: Bool)
    
//    var isInStock: Bool {
//      guard case .inStock = self else { return false }
//      return true
//    }
    
//    var quantity: Int? {
//      get {
//        switch self {
//        case .inStock(quantity: let quantity):
//          return quantity
//        case .outOfStock:
//          return nil
//        }
//      }
//      set {
////        switch self {
////        case .inStock:
////          self = .inStock(quantity: newValue)
////        case .outOfStock:
////          break
////        }
//        guard let quantity = newValue else { return }
//        self = .inStock(quantity: quantity)
//      }
//    }
//
//    var isOnBackOrder: Bool? {
//      get {
//        guard case let .outOfStock(isOnBackOrder) = self else {
////          return false
////          return true
//          return nil
//        }
//        return isOnBackOrder
//      }
//      set {
////        switch self {
////        case .inStock:
////          break
////        case .outOfStock:
//        guard let newValue = newValue else { return }
//        self = .outOfStock(isOnBackOrder: newValue)
////        }
//      }
//    }
  }

  enum Color: String, CaseIterable {
    case blue
    case green
    case black
    case red
    case yellow
    case white
  }

//  static func inStock(
//    name: String,
//    color: Color?,
//    quantity: Int
//  ) -> Self {
//    Item(name: name, color: color, quantity: quantity, isInStock: true, isOnBackOrder: false)
//  }
//
//  static func outOfStock(
//    name: String,
//    color: Color?,
//    isOnBackOrder: Bool
//  ) -> Self {
//    Item(name: name, color: color, quantity: 0, isInStock: false, isOnBackOrder: isOnBackOrder)
//  }
}

extension Binding {

  // (WritableKeyPath<Value, LocalValue>) -> (Binding<Value>) -> Binding<LocalValue>

  // (WritableKeyPath<A, B>) -> (Binding<A>) -> Binding<B>

  // ((A) -> B) -> ([A]) -> [B]
  // ((A) -> B) -> (A?) -> B?
  // ((A) -> B) -> (Result<A, E>) -> Result<B, E>


  // pullback: ((A) -> B) -> (Predicate<B>) -> Predicate<A>
  // pullback: ((A) -> B) -> (Snapshotting<B>) -> Snapshotting<A>


  // pullback: (WritableKeyPath<A, B>) -> (Reducer<B>) -> Reducer<A>



  func map<LocalValue>(_ keyPath: WritableKeyPath<Value, LocalValue>) -> Binding<LocalValue> {

    self[dynamicMember: keyPath]

//    Binding<LocalValue>(
//      get: { self.wrappedValue[keyPath: keyPath] },
//      set: { localValue in self.wrappedValue[keyPath: keyPath] = localValue }
//    )
  }
}

//extension <Wrapped> Binding where Value == Optional<Wrapped> {
extension Binding {
  func unwrap<Wrapped>() -> Binding<Wrapped>? where Value == Wrapped? {
    guard let value = self.wrappedValue else { return nil }
    return Binding<Wrapped>(
      get: { value },
      set: { self.wrappedValue = $0 }
    )
  }

  subscript<Case>(
    casePath: CasePath<Value, Case>
  ) -> Binding<Case>? {
    self.matching(casePath)
  }

  func matching<Case>(
    _ casePath: CasePath<Value, Case>
//    extract: @escaping (Value) -> Case?,
//    embed: @escaping (Case) -> Value
  ) -> Binding<Case>? {
    guard let `case` = casePath.extract(from: self.wrappedValue) else { return nil }
    return Binding<Case>(
      get: { `case` },
      set: { `case` in self.wrappedValue = casePath.embed(`case`) }
    )
  }
}

import CasePaths

struct ItemView: View {
  @Binding var item: Item

  var body: some View {
    Form {
      TextField("Name", text: self.$item.name)

      Picker(selection: self.$item.color, label: Text("Color")) {
        Text("None")
          .tag(Item.Color?.none)

        ForEach(Item.Color.allCases, id: \.rawValue) { color in
          Text(color.rawValue)
            .tag(Optional(color))
        }
      }

      self.$item.status[/Item.Status.inStock].map { quantity in
//      if let quantity = self.$item.status.matching(/Item.Status.inStock) {
        Section(header: Text("In stock")) {
          Stepper("Quantity: \(quantity.wrappedValue)", value: quantity)
          Button("Mark as sold out") {
            self.item.status = .outOfStock(isOnBackOrder: false)
          }
        }
      }

//      self.$item.status.quantity.unwrap().map { (quantity: Binding<Int>) in
//
//      }

//      self.$item.status.isOnBackOrder.unwrap().map { isOnBackOrder in
//      if let isOnBackOrder = self.$item.status[/Item.Status.outOfStock] {
      self.$item.status[/Item.Status.outOfStock].map { isOnBackOrder in
        Section(header: Text("Out of stock")) {
          Toggle("Is on back order?", isOn:
            isOnBackOrder)
          Button("Is back in stock!") {
            self.item.status = .inStock(quantity: 1)
          }
        }
      }
    }
  }
}

struct ContentView: View {
  var body: some View {
    Text("Hello, World!")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {

    struct Wrapper: View {
      @State var item = Item(name: "Keyboard", color: .green, status: .inStock(quantity: 1))

      var body: some View {
        ItemView(item: self.$item)
      }
    }

    return NavigationView {
      Wrapper()
    }
  }
}
