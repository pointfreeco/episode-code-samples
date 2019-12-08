import ComposableArchitecture
import PlaygroundSupport
import PrimeModal
import SwiftUI

PlaygroundPage.current.liveView = UIHostingController(
  rootView: IsPrimeModalView(
    store: Store<PrimeModalState, PrimeModalAction>(
      initialValue: (2, [2, 3, 5]),
      reducer: primeModalReducer
    )
  )
)
