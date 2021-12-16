extension AsyncStream {
  public init(
    _ elementType: Element.Type = Element.self,
    bufferingPolicy: Continuation.BufferingPolicy = .unbounded,
    _ build: @escaping (Continuation) async -> Void
  ) {
    self.init(elementType, bufferingPolicy: bufferingPolicy) { continuation in
      Task {
        await build(continuation)
        continuation.finish()
      }
    }
  }

  public static func passthrough() -> (continuation: Continuation, stream: Self) {
    var continuation: Continuation!
    let stream = Self { continuation = $0 }
    return (continuation, stream)
  }

  public static func yielding(_ element: Element) -> Self {
    Self {
      $0.yield(element)
      $0.finish()
    }
  }

  public static func empty(finishImmediately: Bool = true) -> Self {
    self.init {
      if finishImmediately {
        $0.finish()
      }
    }
  }

//  public static func failing(_ message: String) -> Self {
//    .init {
//      XCTFail("Unimplemented: \(message)")
//      return nil
//    }
//  }
}

extension AsyncThrowingStream where Failure == Error {
  public init(
    _ elementType: Element.Type = Element.self,
    bufferingPolicy: Continuation.BufferingPolicy = .unbounded,
    _ build: @escaping (Continuation) async throws -> Void
  ) {
    self.init(elementType, bufferingPolicy: bufferingPolicy) { continuation in
      Task {
        do {
          try await build(continuation)
          continuation.finish()
        } catch {
          continuation.finish(throwing: error)
        }
      }
    }
  }

  public static func passthrough() -> (continuation: Continuation, stream: Self) {
    var continuation: Continuation!
    let stream = Self { continuation = $0 }
    return (continuation, stream)
  }

  public static func yielding(_ element: Element) -> Self {
    Self {
      $0.yield(element)
      $0.finish()
    }
  }

  public static func throwing(_ error: Error) -> Self {
    self.init { $0.finish(throwing: error) }
  }

  // TODO: Is this name right for vanilla?
  public static func empty(finishImmediately: Bool = true) -> Self {
    self.init {
      if finishImmediately {
        $0.finish()
      }
    }
  }

//  public static func failing(_ message: String) -> Self {
//    .init {
//      XCTFail("Unimplemented: \(message)")
//      return nil
//    }
//  }
}

#if canImport(Combine)
  import Combine

  extension AsyncStream {
    public var publisher: AnyPublisher<Element, Never> {
      let subject = PassthroughSubject<Element, Never>()

      let task = Task {
        await withTaskCancellationHandler {
          subject.send(completion: .finished)
        } operation: {
          for await element in self {
            subject.send(element)
          }
          subject.send(completion: .finished)
        }
      }

      return subject
        .handleEvents(receiveCancel: task.cancel)
        .eraseToAnyPublisher()
    }
  }

  extension AsyncSequence {
    public var publisher: AnyPublisher<Element, Error> {
      let subject = PassthroughSubject<Element, Error>()

      let task = Task {
        do {
          try await withTaskCancellationHandler {
            subject.send(completion: .finished)
          } operation: {
            for try await element in self {
              subject.send(element)
            }
            subject.send(completion: .finished)
          }
        } catch {
          subject.send(completion: .failure(error))
        }
      }

      return subject
        .handleEvents(receiveCancel: task.cancel)
        .eraseToAnyPublisher()
    }
  }
#endif

public struct AsyncRemoveDuplicatesSequence<Base>: AsyncSequence
where
  Base: AsyncSequence,
  Base.Element: Equatable
{
  public typealias Element = Base.Element

  let base: Base

  public __consuming func makeAsyncIterator() -> AsyncIterator {
    .init(base: self.base.makeAsyncIterator())
  }

  public struct AsyncIterator: AsyncIteratorProtocol {
    var base: Base.AsyncIterator
    var previous: Element?

    init(base: Base.AsyncIterator) {
      self.base = base
    }

    public mutating func next() async rethrows -> Element? {
      while let element = try await self.base.next() {
        guard element != self.previous
        else { continue }
        defer { self.previous = element }
        return element
      }
      return nil
    }
  }
}

extension AsyncSequence where Element: Equatable {
  public func removeDuplicates() -> AsyncRemoveDuplicatesSequence<Self> {
    .init(base: self)
  }
}
