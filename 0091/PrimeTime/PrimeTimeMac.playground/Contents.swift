import Counter
import ComposableArchitecture
import PlaygroundSupport

let store = Store(
  initialValue: CounterViewState(),
  reducer: counterViewReducer,
//  environment: { _ in .sync { 17 } }
  environment: Counter.nthPrime
)

let view = CounterView(store: store)

PlaygroundPage.current.setLiveView(view)
