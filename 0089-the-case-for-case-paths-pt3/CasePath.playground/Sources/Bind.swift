import Foundation

public func bind<Model: NSObject, Target, Value>(
  model: Model,
  _ modelKeyPath: KeyPath<Model, Value>,
  to target: Target,
  _ targetKeyPath: ReferenceWritableKeyPath<Target, Value>
) {
  var observation: NSKeyValueObservation!
  observation = model.observe(modelKeyPath, options: [.initial, .new]) { _, change in
    guard let newValue = change.newValue else { return }
    target[keyPath: targetKeyPath] = newValue
    _ = observation
  }
}
