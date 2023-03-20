import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

struct ItemFormFeature: Reducer {
  struct State: Equatable, Identifiable {
    @BindingState var isTimerOn = false
    @BindingState var item: Item

    var id: Item.ID { self.item.id }
  }
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case timerTick
  }
  @Dependency(\.continuousClock) var clock
  @Dependency(\.dismiss) var dismiss

  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .binding(\.$isTimerOn):
        if state.isTimerOn {
          return .run { send in
            var tickCount = 0
            for await _ in self.clock.timer(interval: .seconds(1)) {
              await send(.timerTick)
              tickCount += 1
              if tickCount == 3 {
                await self.dismiss()
              }
            }
          }
          .cancellable(id: CancelID.timer)
        } else {
          return .cancel(id: CancelID.timer)
        }

      case .binding:
        return .none

      case .timerTick:
        guard case let .inStock(quantity) = state.item.status
        else { return .none }
        state.item.status = .inStock(quantity: quantity + 1)
//        if quantity == 3 {
//          self.dismiss()
//        }
//        URLSession.shared.dataTask(with: ...) { data, _, _ in
//
//        }.resume()
        return .none
//        return quantity == 3
//        ? .fireAndForget { await self.dismiss() }
//        : .none
      }
    }
  }

  private enum CancelID {
    case timer
  }
}

struct ItemFormView: View {
  @Environment(\.dismiss) var dismiss
  let store: StoreOf<ItemFormFeature>

//  init() {
//    //        _ = URLSession...
//  }

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        TextField("Name", text: viewStore.binding(\.$item.name))

//        _ = URLSession...
//        _ = self.dismiss()

        HStack {
          Picker("Color", selection: viewStore.binding(\.$item.color)) {
            Text("None")
              .tag(Item.Color?.none)
            ForEach(Item.Color.defaults) { color in
              ZStack {
                RoundedRectangle(cornerRadius: 4)
                  .fill(color.swiftUIColor)
                Label(color.name, systemImage: "paintpalette")
                  .padding(4)
              }
              .fixedSize(horizontal: false, vertical: true)
              .tag(Optional(color))
            }
          }

          if let color = viewStore.item.color {
            Rectangle()
              .frame(width: 30, height: 30)
              .foregroundColor(color.swiftUIColor)
              .border(Color.black, width: 1)
          }
        }

        Switch(viewStore.binding(\.$item.status)) {
          CaseLet(/Item.Status.inStock) { $quantity in
            Section(header: Text("In stock")) {
              Stepper("Quantity: \(quantity)", value: $quantity)
              Button("Mark as sold out") {
                viewStore.send(
                  .set(\.$item.status, .outOfStock(isOnBackOrder: false)),
                  animation: .default
                )
              }
            }
          }
          CaseLet(/Item.Status.outOfStock) { $isOnBackOrder in
            Section(header: Text("Out of stock")) {
              Toggle("Is on back order?", isOn: $isOnBackOrder)
              Button("Is back in stock!") {
                viewStore.send(
                  .set(\.$item.status, .inStock(quantity: 1)),
                  animation: .default
                )
              }
            }
          }
        }

        Toggle("Timer", isOn: viewStore.binding(\.$isTimerOn))

        Button("Dismiss") { self.dismiss() }
      }
    }
  }
}

struct ItemForm_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      ItemFormView(
        store: Store(
          initialState: ItemFormFeature.State(item: .headphones),
          reducer: ItemFormFeature()
        )
      )
    }
  }
}
