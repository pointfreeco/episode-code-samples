import Dependencies
import DependenciesTestSupport
import Foundation
import Testing
@testable import TourOfSharing

@Suite
@MainActor
struct FactFeatureTests {
  @Test(
    .dependency(FactClient.goodFacts),
    .dependency(\.date.now, Date(timeIntervalSince1970: 1234567890)),
    .dependency(\.uuid, .incrementing)
  ) func basics() async {
    let model = FactFeatureModel()

    model.incrementButtonTapped()
    #expect(model.count == 1)

    await model.getFactButtonTapped()
    #expect(model.count == 1)
    #expect(model.fact == "1 is a good number!")

    model.favoriteFactButtonTapped()
    #expect(
      model.favoriteFacts == [Fact(
        id: UUID(0),
        number: 1,
        savedAt: Date(timeIntervalSince1970: 1234567890),
        value: "1 is a good number!"
      )]
    )

    model.deleteFacts(indexSet: [0])
    #expect(model.favoriteFacts == [])
  }
}
