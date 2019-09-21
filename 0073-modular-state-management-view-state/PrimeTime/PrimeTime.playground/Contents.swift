
import ComposableArchitecture

let store = Store<Int, ()>(initialValue: 0, reducer: { count, _ in count += 1 })

store.send(())
store.send(())
store.send(())
store.send(())
store.send(())

store.value

let newStore = store.view { $0 }

newStore.value
newStore.send(())
newStore.send(())
newStore.send(())
newStore.value

store.value

store.send(())
store.send(())
store.send(())

newStore.value
store.value

var xs = [1, 2, 3]
var ys = xs.map { $0 }

ys.append(4)

xs
ys
