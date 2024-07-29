import Foundation

struct Network: Identifiable, Hashable {
  let id = UUID()
  var name = ""
  var isSecured = true
  var connectivity = 1.0
}
