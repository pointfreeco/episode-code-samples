import UIKitNavigation

extension UIBinding {
  @MainActor
  init(wrappedValue: Value) {
    @UIBindable var wrapper = Wrapper(wrappedValue)
    self = $wrapper.value
  }
}

@Perceptible
private final class Wrapper<Value> {
  var value: Value
  init(_ value: Value) {
    self.value = value
  }
}
