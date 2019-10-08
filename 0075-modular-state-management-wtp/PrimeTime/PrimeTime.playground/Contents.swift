import ComposableArchitecture
import Counter
import FavoritePrimes
import PrimeModal
import SwiftUI
import PlaygroundSupport


PlaygroundPage.current.liveView = UIHostingController(
  rootView: CounterView(
    store: Store<CounterViewState, CounterViewAction>(
      initialValue: (1_000_000, []),
      reducer: counterViewReducer
    )
  )
)


//PlaygroundPage.current.liveView = UIHostingController(
//  rootView: IsPrimeModalView(
//    store: Store<PrimeModalState, PrimeModalAction>(
//      initialValue: (2, [2, 3, 5]),
//      reducer: primeModalReducer
//    )
//  )
//)


//
//PlaygroundPage.current.liveView = UIHostingController(
//  rootView: FavoritePrimesView(
//    store: Store<[Int], FavoritePrimesAction>(
//      initialValue: [2, 3, 5, 7, 11],
//      reducer: favoritePrimesReducer
//    )
//  )
//)




//let store = Store<Int, ()>(initialValue: 0, reducer: { count, _ in count += 1 })
//
//store.send(())
//store.send(())
//store.send(())
//store.send(())
//store.send(())
//
//store.value
//
//let newStore = store.view { $0 }
//
//newStore.value
//newStore.send(())
//newStore.send(())
//newStore.send(())
//newStore.value
//
//store.value
//
//store.send(())
//store.send(())
//store.send(())
//
//newStore.value
//store.value
//
//var xs = [1, 2, 3]
//var ys = xs.map { $0 }
//
//ys.append(4)
//
//xs
//ys
//
