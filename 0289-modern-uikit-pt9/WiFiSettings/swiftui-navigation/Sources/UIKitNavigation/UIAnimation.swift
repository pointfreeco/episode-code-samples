import UIKit

// TODO: Support arbitrary body closures, `CASpringAnimation`?

public struct UIAnimation: Sendable {
  @TaskLocal static var current: Self?

  public static var `default`: Self {
    if #available(iOS 17, *) {
      return Self(storage: .animate_iOS_17())
    } else {
      return Self(storage: .animate_iOS_4(withDuration: 0.2))
    }
  }

  fileprivate let storage: Storage

  fileprivate enum Storage {
    case animate_iOS_4(
      withDuration: TimeInterval,
      delay: CGFloat = 0,
      options: UIView.AnimationOptions = []
    )
    case animate_iOS_7(
      withDuration: TimeInterval,
      delay: TimeInterval,
      usingSpringWithDamping: CGFloat,
      initialSpringVelocity: CGFloat,
      options: UIView.AnimationOptions = []
    )
    case animate_iOS_17(
      springDuration: TimeInterval = 0.5,
      bounce: CGFloat = 0,
      initialSpringVelocity: CGFloat = 0,
      delay: TimeInterval = 0,
      options: UIView.AnimationOptions = []
    )
  }
}

@MainActor
public func withUIAnimation<Result>(
  _ animation: UIAnimation? = .default,
  @_implicitSelfCapture body: () throws -> Result,
  completion: ((Bool) -> Void)? = nil
) rethrows -> Result {
  switch animation?.storage {
  case let .animate_iOS_4(duration, delay, options):
    var result: Swift.Result<Result, Error>?
    withoutActuallyEscaping(body) { body in
      UIView.animate(
        withDuration: duration,
        delay: delay,
        options: options,
        animations: {
          result = Swift.Result {
            try UIAnimation.$current.withValue(animation) {
              try body()
            }
          }
        },
        completion: completion
      )
    }
    return try result!._rethrowGet()
  case let .animate_iOS_7(duration, delay, damping, initialSpringVelocity, options):
    var result: Swift.Result<Result, Error>?
    withoutActuallyEscaping(body) { body in
      UIView.animate(
        withDuration: duration,
        delay: delay,
        usingSpringWithDamping: damping,
        initialSpringVelocity: initialSpringVelocity,
        options: options,
        animations: {
          result = Swift.Result {
            try UIAnimation.$current.withValue(animation) {
              try body()
            }
          }
        },
        completion: completion
      )
    }
    return try result!._rethrowGet()
  case let .animate_iOS_17(springDuration, bounce, initialSpringVelocity, delay, options):
    if #available(iOS 17, *) {
      var result: Swift.Result<Result, Error>?
      UIView.animate(
        springDuration: springDuration,
        bounce: bounce,
        initialSpringVelocity: initialSpringVelocity,
        delay: delay,
        options: options,
        animations: { result = Swift.Result { try body() } },
        completion: completion
      )
      return try result!._rethrowGet()
    } else {
      return try UIAnimation.$current.withValue(animation) {
        try body()
      }
    }
  case nil:
    return try UIAnimation.$current.withValue(animation) {
      try body()
    }
  }
}
