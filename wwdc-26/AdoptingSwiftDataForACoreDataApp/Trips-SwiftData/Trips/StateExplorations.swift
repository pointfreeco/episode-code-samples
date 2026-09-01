import SwiftUI
import LazyState

@Observable class Model {
  var count: Int
  init(count: Int) {
    self.count = count
    print("Model.init")
  }
  deinit {
    print("Model.deinit")
  }
}

struct ChildView: View {
  @LazyState private var model: Model

  init(count: Int) {
    _model = LazyState { Model(count: count) }
    print("ChildView.init(count: \(count))")
  }
  var body: some View {
    Text("Child \(model.count)")
    Stepper("Count", value: $model.count)

    Button("+") {
      model.count += 1
    }
  }
}

struct ParentView: View {
  @State var perturb = 0
  var body: some View {
    let _ = print("ParentView.body")
    VStack {
      ChildView(count: perturb)
      Button("Perturb \(perturb)") { perturb += 1 }
    }
  }
}
#Preview {
  ParentView()
}
