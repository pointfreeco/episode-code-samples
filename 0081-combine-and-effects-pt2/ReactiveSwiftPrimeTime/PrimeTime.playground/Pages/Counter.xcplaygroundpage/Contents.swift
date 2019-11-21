import ComposableArchitecture
import Counter
import PlaygroundSupport
import SwiftUI

PlaygroundPage.current.liveView = UIHostingController(
  rootView: CounterView(
    store: Store<CounterViewState, CounterViewAction>(
      initialValue: CounterViewState(
        alertNthPrime: nil,
        count: 0,
        favoritePrimes: [],
        isNthPrimeButtonDisabled: false
      ),
      reducer: logging(counterViewReducer)
    )
  )
)
