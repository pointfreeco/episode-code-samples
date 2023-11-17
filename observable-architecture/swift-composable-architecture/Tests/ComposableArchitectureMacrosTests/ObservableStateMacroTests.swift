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
            withMutation(keyPath: \.count) {
              _count = newValue
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
}
