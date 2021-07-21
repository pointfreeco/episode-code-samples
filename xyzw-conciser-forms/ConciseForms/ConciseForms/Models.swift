struct AlertState: Equatable, Identifiable {
  var title: String
  var id: String { self.title }
}

enum Digest: String, CaseIterable {
  case daily
  case weekly
  case off
}
