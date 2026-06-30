import MyLibrary

// @MainActor
final class Model {

}
nonisolated extension Model: MyProtocol {
  func operate() {}
}

//nonisolated
func test() async {
  let model = Model()
  model.operate()
  await launder(model)
}

@concurrent func launder(_ model: some MyProtocol) async {
  model.operate()
}
