import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
  var circleCenter = CGPoint.zero
  var circleColor = Color.black
  var isCircleScaled = false
}

enum AppAction {
  case cycleColorsButtonTapped
  case dragGesture(CGPoint)
  case resetButtonTapped
  case setCircleColor(Color)
  case toggleScale(isOn: Bool)
}

struct AppEnvironment {}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> {
  state, action, environment in
  switch action {
  case .cycleColorsButtonTapped:
    state.circleColor = .red
    return Effect.concatenate(
      [Color.blue, .green, .purple, .black].map { color in
        Effect(value: .setCircleColor(color))
          .delay(for: .seconds(1), scheduler: DispatchQueue.main)
          .eraseToEffect()
      }
//      Effect(value: AppAction.setCircleColor(.blue))
//        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
//        .eraseToEffect(),
//      Effect(value: AppAction.setCircleColor(.green))
//        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
//        .eraseToEffect(),
//      Effect(value: AppAction.setCircleColor(.purple))
//        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
//        .eraseToEffect(),
//      Effect(value: AppAction.setCircleColor(.black))
//        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
//        .eraseToEffect()
    )

  case let .dragGesture(location):
    state.circleCenter = location
    return .none
    
  case .resetButtonTapped:
    state = AppState()
    return .none
    
  case let .setCircleColor(color):
    state.circleColor = color
    return .none
    
  case .toggleScale(isOn: let isOn):
    state.isCircleScaled = isOn
    return .none
  }
}

struct TCAContentView: View {
  let store: Store<AppState, AppAction>
//  @State var circleCenter = CGPoint.zero
//  @State var circleColor = Color.black
//  @State var isCircleScaled = false
//  @State var isResetting = false

  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        Circle()
          .fill(viewStore.circleColor)
          //        .animation(.linear)
          .overlay(Text("Hi"))
          .frame(width: 50, height: 50)
          .scaleEffect(viewStore.isCircleScaled ? 2 : 1)
          //        .animation(nil, value: self.isCircleScaled)
          //        .animation(.disabled)
          .offset(x: viewStore.circleCenter.x - 25, y: viewStore.circleCenter.y - 25)
          .animation(.spring(response: 0.3, dampingFraction: 0.1))
          .gesture(
            DragGesture(minimumDistance: 0).onChanged { value in
//              withAnimation(.spring(response: 0.3, dampingFraction: 0.1)) {
//                viewStore.circleCenter = value.location
                viewStore.send(.dragGesture(value.location))
//              }
            }
          )
          .foregroundColor(viewStore.isCircleScaled ? .red : nil)
        //      if self.isCircleScaled {
        //        circle.foregroundColor(.red)
        //      } else {
        //        circle
        //      }
        
        Toggle(
          "Scale",
          isOn: viewStore.binding(
            get: \.isCircleScaled,
            send: AppAction.toggleScale(isOn:)
          )
          .animation(.spring(response: 0.3, dampingFraction: 0.1))
//            self.$isCircleScaled.animation(.spring(response: 0.3, dampingFraction: 0.1))
          
          //          Binding(
          //          get: { self.isCircleScaled },
          //          set: { isOn in
          //            withAnimation(.spring(response: 0.3, dampingFraction: 0.1)) {
          //              self.isCircleScaled = isOn
          //            }
          //          }
          //        )
          
        )
        
        Button("Cycle colors") {
          withAnimation(.linear) {
            viewStore.send(.cycleColorsButtonTapped)
          }
//          [Color.red, .blue, .green, .purple, .black]
//            .enumerated()
//            .forEach { offset, color in
//              DispatchQueue.main.asyncAfter(deadline:   .now() + .seconds(offset)) {
//                withAnimation(.linear) {
//                  self.circleColor = color
//                }
//
//                // withAnimation: (() -> R) -> R
//                // Async<A> = ((A) -> Void) -> Void
//                //            ((A) -> R) -> R
//              }
//            }
          //        DispatchQueue.main.asyncAfter(deadline:   .now() + 1) {
          //          self.circleColor = .blue
          //        }
          //        DispatchQueue.main.asyncAfter(deadline:   .now() + 2) {
          //          self.circleColor = .green
          //        }
          //        DispatchQueue.main.asyncAfter(deadline:   .now() + 3) {
          //          self.circleColor = .purple
          //        }
          //        DispatchQueue.main.asyncAfter(deadline:   .now() + 4) {
          //          self.circleColor = .black
          //        }
        }
        
        Button("Reset") {
//          withAnimation {
            viewStore.send(.resetButtonTapped)
//          }
          //        self.isResetting = true
//          withAnimation {
//            self.circleCenter = .zero
//            self.circleColor = .black
//          }
//          self.isCircleScaled = false
          //        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
          //          self.isResetting = false
          //        }
        }
      }
    }
  }
}

struct TCAContentView_Previews: PreviewProvider {
  static var previews: some View {
    TCAContentView(
      store: Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
      )
    )
  }
}
