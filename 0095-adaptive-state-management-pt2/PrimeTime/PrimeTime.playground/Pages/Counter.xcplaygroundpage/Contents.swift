import ComposableArchitecture
@testable import Counter
import PlaygroundSupport
import SwiftUI

PlaygroundPage.current.liveView = UIHostingController(
  rootView: CounterView(
    store: Store(
      initialValue: CounterFeatureState(
        alertNthPrime: nil,
        count: 0,
        favoritePrimes: [],
        isNthPrimeRequestInFlight: false
      ),
      reducer: logging(counterViewReducer),
      environment: { _ in .sync { 7236893748932 } }
    )
  )
)
