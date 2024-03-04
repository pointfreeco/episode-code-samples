import ComposableArchitectureMacros
import MacroTesting
import XCTest

final class ObservableStateMacroTests: XCTestCase {
  override func invokeTest() {
    withMacroTesting(
      isRecording: true,
      macros: [
        ObservableStateMacro.self,
        ObservationStateIgnoredMacro.self,
        ObservationStateTrackedMacro.self,
      ]
    ) {
      super.invokeTest()
    }
  }

  func testBasics() {
    assertMacro {
      """
      @ObservableState
      struct State {
        var count = 0
      }
      """
    } expansion: {
      #"""
      struct State {
        var count = 0 {
          @storageRestrictions(initializes: _count)
          init(initialValue) {
            _count = initialValue
          }
          get {
            access(keyPath: \.count)
            return _count
          }
          set {
            if _$isIdentityEqual(_count, newValue) {
              _count = newValue
            } else {
              withMutation(keyPath: \.count) {
              _count = newValue
              }
            }
          }
        }

        public let _$id = UUID()

        private let _$observationRegistrar = Observation.ObservationRegistrar()

        internal nonisolated func access<Member>(
          keyPath: KeyPath<State, Member>
        ) {
          _$observationRegistrar.access(self, keyPath: keyPath)
        }

        internal nonisolated func withMutation<Member, MutationResult>(
          keyPath: KeyPath<State, Member>,
          _ mutation: () throws -> MutationResult
        ) rethrows -> MutationResult {
          try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
        }
      }
      """#
    }
  }

  func testPresentationState() {
    assertMacro {
      """
      @ObservableState
      struct State {
        @PresentationState var destination: Child.State?
      }
      """
    } expansion: {
      """
      struct State {
        @PresentationState var destination: Child.State?

        public let _$id = UUID()

        private let _$observationRegistrar = Observation.ObservationRegistrar()

        internal nonisolated func access<Member>(
          keyPath: KeyPath<State, Member>
        ) {
          _$observationRegistrar.access(self, keyPath: keyPath)
        }

        internal nonisolated func withMutation<Member, MutationResult>(
          keyPath: KeyPath<State, Member>,
          _ mutation: () throws -> MutationResult
        ) rethrows -> MutationResult {
          try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
        }
      }
      """
    }
  }

  func testEnum() {
    assertMacro {
      """
      @ObservableState
      enum State {
        case feature1(Feature1.State)
        case feature2(Feature2.State)
      }
      """
    } expansion: {
      """
      enum State {
        case feature1(Feature1.State)
        case feature2(Feature2.State)

        var _$id: UUID {
          switch self {
          case let .feature1(state):
          return state._$id
          case let .feature2(state):
            return state._$id
          }
        }
      }
      """
    }
  }
}
