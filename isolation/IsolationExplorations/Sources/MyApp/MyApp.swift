// @MainActor
final class Model {
  func operate() {}
}

nonisolated func test() {
  let model = Model()
  model.operate()
}

actor Bank {
  var totalDeposits: Int {
    0
  }
}

// @MainActor
func bank() {
  let bank = Bank()
  bank.totalDeposits
}
