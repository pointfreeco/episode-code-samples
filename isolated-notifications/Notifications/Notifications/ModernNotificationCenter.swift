import Foundation
import OrderedCollections

final class ModernNotificationCenter: Sendable {
  static let `default` = ModernNotificationCenter()

  @MainActor
  private var observers: [ObjectIdentifier: OrderedDictionary<UUID, @MainActor (any MainActorMessage) -> Void>] = [:]

  @MainActor
  func post<M: MainActorMessage>(_ message: M) {
    let type = ObjectIdentifier(M.self)
    let observers = observers[type, default: [:]].values
    for observer in observers {
      observer(message)
    }
  }

  @MainActor
  func addObserver<M: MainActorMessage>(
    for type: M.Type,
    using observer: @escaping @MainActor (M) -> Void
  ) -> ObservationToken {
    let type = ObjectIdentifier(type)
    let id = UUID()
    observers[type, default: [:]][id] = { anyMainActorMessage in
      observer(anyMainActorMessage as! M)
    }
    return ObservationToken { [self] in
      observers[type]?.removeValue(forKey: id)
    }
  }

  @MainActor
  final class ObservationToken {
    private let onCancel: () -> Void
    init(onCancel: @escaping () -> Void) {
      self.onCancel = onCancel
    }
    func cancel() { onCancel() }
    isolated deinit { onCancel() }
  }

  protocol MainActorMessage {}
}

