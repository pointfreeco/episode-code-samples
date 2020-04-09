import ComposableArchitecture
@testable import Counter
import PlaygroundSupport
import SwiftUI

PlaygroundPage.current.setLiveView(
  CounterView(
    store: Store(
      initialValue: CounterFeatureState(
        alertNthPrime: nil,
        count: 0,
        favoritePrimes: [],
        isNthPrimeRequestInFlight: false
      ),
      reducer: logging(counterFeatureReducer),
      environment: Counter.nthPrime
    )
  )
)
