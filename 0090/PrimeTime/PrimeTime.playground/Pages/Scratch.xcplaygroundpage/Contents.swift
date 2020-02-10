import ComposableArchitecture
import PrimeModal

let store = Store<Void, Never>(initialValue: (), reducer: { _, _ in [] })
