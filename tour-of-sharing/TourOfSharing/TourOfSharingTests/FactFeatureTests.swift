import Dependencies
import DependenciesTestSupport
import Foundation
import Testing
@testable import TourOfSharing

@Suite // (.serialized)
@MainActor
struct FactFeatureTests {
  @Test(
    .dependency(FactClient.goodFacts),
    .dependency(\.date.now, Date(timeIntervalSince1970: 1234567890)),
    .dependency(\.uuid, .incrementing)
  ) func basics() async {
    let model = FactFeatureModel(); print(#function)

    model.incrementButtonTapped(); print(#function)
    #expect(model.count == 1); print(#function)

    await model.getFactButtonTapped(); print(#function)
    #expect(model.count == 1); print(#function)
    #expect(model.fact == "1 is a good number!"); print(#function)

    model.favoriteFactButtonTapped(); print(#function)
    #expect(
      model.favoriteFacts == [Fact(
        id: UUID(0),
        number: 1,
        savedAt: Date(timeIntervalSince1970: 1234567890),
        value: "1 is a good number!"
      )]
    ); print(#function)

    model.deleteFacts(indexSet: [0]); print(#function)
    #expect(model.favoriteFacts == []); print(#function)

    #expect(model.events == [
      "Increment Button Tapped",
      "Get Fact Button Tapped",
      "Favorite Fact Button Tapped",
      "Delete Facts",
    ])
  }


  @Test(
    .dependency(FactClient.goodFacts),
    .dependency(\.date.now, Date(timeIntervalSince1970: 1234567890)),
    .dependency(\.uuid, .incrementing)
  ) func anotherBasics() async {
    let model = FactFeatureModel(); print(#function)

    model.incrementButtonTapped(); print(#function)
    #expect(model.count == 1); print(#function)

    await model.getFactButtonTapped(); print(#function)
    #expect(model.count == 1); print(#function)
    #expect(model.fact == "1 is a good number!"); print(#function)

    model.favoriteFactButtonTapped(); print(#function)
    #expect(
      model.favoriteFacts == [Fact(
        id: UUID(0),
        number: 1,
        savedAt: Date(timeIntervalSince1970: 1234567890),
        value: "1 is a good number!"
      )]
    ); print(#function)

    model.deleteFacts(indexSet: [0]); print(#function)
    #expect(model.favoriteFacts == []); print(#function)

    #expect(model.events == [
      "Increment Button Tapped",
      "Get Fact Button Tapped",
      "Favorite Fact Button Tapped",
      "Delete Facts",
    ])
  }
}
