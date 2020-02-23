import ComposableArchitecture
@testable import Counter
import PlaygroundSupport
import SwiftUI

1

Current = .mock
//let environment = CounterEnvironment(nthPrime: { _ in .sync { 17 } })
Current.nthPrime = { _ in .sync { 7236893748932 }}

PlaygroundPage.current.liveView = UIHostingController(
  rootView: CounterView(
    store: Store<CounterViewState, CounterViewAction>(
      initialValue: CounterViewState(
        alertNthPrime: nil,
        count: 0,
        favoritePrimes: [],
        isNthPrimeRequestInFlight: false
      ),
      reducer: (counterViewReducer)
    )
  )
)
