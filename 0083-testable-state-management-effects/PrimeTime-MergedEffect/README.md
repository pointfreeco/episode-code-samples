## Composable Architecture With Merged Effects

Applied Changes:
---------------

This version of the project replaces the usage of `[Effect<Action>]` with an `Effect<Action>` in the reducer typealias as the following

**Before:**

```swift
public typealias Reducer<Value, Action> = (inout Value, Action) -> [Effect<Action>]
```
**After:**
```swift
public typealias Reducer<Value, Action> = (inout Value, Action) -> Effect<Action>
```

In this case our `Reducer` always returns an `Effect`, what if the applied action doesn't return an Effect? well so we need to extend the `Effect` type so we could have an `emptyEffect` that does nothing.

we can achive that by the below extension on `Effect`:


```swift
public extension Effect {
  static func emptyEffect(completeImmediately: Bool = true) -> Effect {
    return Empty<Output, Never>(completeImmediately: completeImmediately).eraseToEffect()
  }
}
```
with the above in place, it could be used as a return value for every action that doesn't need any effect to be returned.

**example:**
```swift

public func primeModalReducer(state: inout PrimeModalState, action: PrimeModalAction) -> Effect<PrimeModalAction> {
  switch action {
  case .removeFavoritePrimeTapped:
    state.favoritePrimes.removeAll(where: { $0 == state.count })
    return .emptyEffect()

  case .saveFavoritePrimeTapped:
    state.favoritePrimes.append(state.count)
    return .emptyEffect()
  }
}
```

in order to combine multiple effects in combine reducers function we could use `Combine's MergeMany` function like the following:

```swift
public func combine<Value, Action>(
  _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
  return { value, action in
    let effects = reducers.flatMap { $0(&value, action) }
    return Publishers.MergeMany(effects).eraseToEffect()
  }
}
```

in this way we unified the effect(s) to be one effect only, even if any action returns muliple effects we can use one of `Combine's Merge` overloads.

### Testing

when it comes to test we can test the effects as usual, in case we have an empty effect we could assert that it doesn't output any value `effects.sink { _ in XCTFail() }`

**example:**

```swift
  func testPrimeModal() {
    ...

    var effects = counterViewReducer(&state, .primeModal(.saveFavoritePrimeTapped))

    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 2,
        favoritePrimes: [3, 5, 2],
        isNthPrimeButtonDisabled: false
      )
    )
    effects.sink { _ in XCTFail() }

    effects = counterViewReducer(&state, .primeModal(.removeFavoritePrimeTapped))

    XCTAssertEqual(
      state,
      CounterViewState(
        alertNthPrime: nil,
        count: 2,
        favoritePrimes: [3, 5],
        isNthPrimeButtonDisabled: false
      )
    )
    effects.sink { _ in XCTFail() }
  }
```