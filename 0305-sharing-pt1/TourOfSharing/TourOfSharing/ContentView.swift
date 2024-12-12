import Sharing
import SwiftUI

struct ManyCountersView: View {
  @Shared(.appStorage("count")) var count = 0

  var body: some View {
    Form {
      Section {
        CounterView()
      }

      Section {
        CounterView()
      }

      Button(#"UserDefaults.set(0, "count")"#) {
        withAnimation {
          $count.withLock { $0 = 0 }
//          UserDefaults.standard.set(
//            0,
//            forKey: "count"
//          )
        }
      }
    }
  }
}

@Observable
class CounterModel {
  @ObservationIgnored
  @Shared(.appStorage("count")) var count = 0
  //@AppStorage("co.pointfree.countermodel.count") var count = 0
}

struct CounterView: View {
  @State var model = CounterModel()

  var body: some View {
    Text("\(model.count)")
      .font(.largeTitle)
    Button("Decrement") {
      //model.count -= 1
      model.$count.withLock { $0 -= 1 }
    }
    Button("Increment") {
      //model.count += 1
      model.$count.withLock { $0 += 1 }
    }
//    Button("Race!") {
//      Task {
//        await withTaskGroup(of: Void.self) { [sharedCount = model.$count] group in
//          for _ in 1...1_000 {
//            group.addTask {
//              sharedCount.withLock { $0 += 1 }
//            }
//          }
//        }
//      }
//    }
  }
}

#Preview("CounterView") {
  CounterView()
}

#Preview("ManyCountersView") {
  ManyCountersView()
}



struct AppStorageRaceCondition: View {
  @AppStorage("racey-count") var count = 0
  var body: some View {
    Form {
      Text("\(count)")
      Button("Race!") {
        Task {
          await withTaskGroup(of: Void.self) { group in
            for _ in 1...1_000 {
              group.addTask {
                await MainActor.run {
                  count += 1
                }
                //_count.wrappedValue += 1
              }
            }
          }
        }
      }
    }
  }
}

#Preview("AppStorage race condition") {
  AppStorageRaceCondition()
}
