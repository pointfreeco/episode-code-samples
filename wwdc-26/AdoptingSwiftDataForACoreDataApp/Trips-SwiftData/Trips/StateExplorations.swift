import SwiftUI

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
  @State private var model: Model?
  let count: Int
  init(count: Int) {
    self.count = count
    print("ChildView.init(count: \(count))")
  }
  var body: some View {
    Text("Child \(model?.count ?? 0)")
      .onAppear {
        model = Model(count: count)
      }

    Button("+") {
      model?.count += 1
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
