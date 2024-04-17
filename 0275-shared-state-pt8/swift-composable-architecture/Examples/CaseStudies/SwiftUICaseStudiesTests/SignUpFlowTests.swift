import ComposableArchitecture
import XCTest

@testable import SwiftUICaseStudies

final class SignUpFlowTests: XCTestCase {
  @MainActor
  func testBasics() async {
    let signUpData = Shared(SignUpData())

    let store = TestStore(
      initialState: SignUpFeature.State(
        path: StackState([
          .basics(BasicsFeature.State(signUpData: signUpData)),
          .personalInfo(PersonalInfoFeature.State(signUpData: signUpData)),
          .topics(TopicsFeature.State(signUpData: signUpData))
        ]),
        signUpData: signUpData
      )
    ) {
      SignUpFeature()
    }

    await store.send(\.path[id: 2].topics.nextButtonTapped) {
      //$0.path[id: 3] = …
      $0.path[id: 2]?.topics?.alert = AlertState {
        TextState("Please choose at least one topic.")
      }
    }
    await store.send(
      \.path[id: 2].topics.binding.signUpData,
       SignUpData(topics: [.testing])
    ) {
      $0.signUpData.topics = [.testing]
    }
    await store.send(\.path[id: 2].topics.nextButtonTapped)
    await store.receive(\.path[id: 2].topics.delegate.stepFinished) {
      $0.path[id: 3] = .summary(SummaryFeature.State(signUpData: signUpData))
    }
    await store.send(\.path[id: 3].summary.editPersonalInfoButtonTapped) {
      $0.path[id: 3]?.summary?.destination = .personalInfo(
        PersonalInfoFeature.State(signUpData: signUpData)
      )
    }
    await store.send(
      \.path[id: 3].summary.destination.personalInfo.binding.signUpData,
       SignUpData(firstName: "Blob", topics: [.testing])
    ) {
      $0.signUpData.firstName = "Blob"
    }
    await store.send(\.path[id: 3].summary.destination.dismiss) {
      $0.path[id: 3]?.summary?.destination = nil
    }
  }
}
