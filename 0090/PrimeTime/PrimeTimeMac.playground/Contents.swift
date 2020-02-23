import PlaygroundSupport
import ComposableArchitecture
import Counter

let store = Store(initialValue: CounterViewState(), reducer: counterViewReducer)
let view = CounterView(store: store)
//.environment(\.colorScheme, .light)

PlaygroundPage.current.setLiveView(view)
