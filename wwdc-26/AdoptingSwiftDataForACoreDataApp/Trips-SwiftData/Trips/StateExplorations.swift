import SwiftUI

@Observable class Model {
  init() {
    print("Model.init")
  }
  deinit {
    print("Model.deinit")
  }
}

struct ChildView: View {
  @State private var model = Model()
  init() {
    print("ChildView.init")
  }
  var body: some View {
    Text("Child")
  }
}

struct ParentView: View {
  @State var perturb = 0
  var body: some View {
    let _ = print("ParentView.body")
    VStack {
      ChildView()
      Button("Perturb \(perturb)") { perturb += 1 }
    }
  }
}
#Preview {
  ParentView()
}
