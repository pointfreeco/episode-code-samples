
struct IncrementMessage: NotificationCenter.Message {}
struct MainActorIncrementMessage: NotificationCenter.MainActorMessage {}

for await message in NotificationCenter.default.messages(for: IncrementMessage.self) {
  count += 1
}

await NotificationCenter.default.post(IncrementMessage())
#expect(count == 1)

var rows = …

await database.write { … }

rows

withAnimation {
  NotificationCenter.default.post(MainActorIncrementMessage())
}
