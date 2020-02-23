import SwiftUI
import PlaygroundSupport
import ComposableArchitecture
import Counter

let store = Store(initialValue: CounterViewState(), reducer: counterViewReducer)
let view = CounterView(store: store)

PlaygroundPage.current.liveView = NSHostingController(rootView: view)

1

