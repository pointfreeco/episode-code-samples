import SwiftUI

struct ManyCountersView: View {
  var body: some View {
    Form {
      Section {
        CounterView()
      }

      Section {
        CounterView()
      }

      Button(#"UserDefaults.set(0, "count")"#) {
        UserDefaults.standard.set(
          0,
          forKey: "count"
        )
      }
    }
  }
}

@Observable
class CounterModel {
  @ObservationIgnored
  @AppStorage("count") var count = 0
}

struct CounterView: View {
  @State var model = CounterModel()

  var body: some View {
    Text("\(model.count)")
      .font(.largeTitle)
    Button("Decrement") {
      model.count -= 1
    }
    Button("Increment") {
      model.count += 1
    }
  }
}

#Preview("CounterView") {
  CounterView()
}

#Preview("ManyCountersView") {
  ManyCountersView()
}
