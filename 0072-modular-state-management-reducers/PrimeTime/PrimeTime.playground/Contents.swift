
import ComposableArchitecture


let store = Store<Int, Void>(initialValue: 0, reducer: { count, _ in count += 1 })

store.send(())
store.value // 1
store.send(())
store.value // 2
store.send(())
store.value // 3


let newStore = store.view { $0 }

newStore.send(())
newStore.value // 4
newStore.send(())
newStore.value // 5
newStore.send(())
newStore.value // 6

store.send(())
store.value
newStore.value
