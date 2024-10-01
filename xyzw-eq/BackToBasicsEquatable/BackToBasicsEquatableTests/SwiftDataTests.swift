import SwiftData
import Testing

@Model
class Item {
  var name: String
  init(name: String) {
    self.name = name
  }
}

@Test
func model() async throws {
  let schema = Schema([
    Item.self,
  ])
  let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
  let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
  let context = ModelContext(modelContainer)

  let item = Item(name: "Blob")
  context.insert(item)
  try context.save()

  let fetchedItem = try context.fetch(FetchDescriptor<Item>()).first!

  #expect(fetchedItem == item)
  #expect(fetchedItem === item)

  do {
    let context = ModelContext(item.modelContext!.container)

    let fetchedItem = try context.fetch(FetchDescriptor<Item>()).first!

    #expect(fetchedItem.name == item.name)
    #expect(fetchedItem.id == item.id)

    #expect(fetchedItem == item)
    #expect(fetchedItem === item)
  }
}
