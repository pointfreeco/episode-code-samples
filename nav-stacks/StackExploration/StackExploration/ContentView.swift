import SwiftUI

struct CounterDestination: Hashable {
  var initialCount = 0
  var fact: FactSheetState?
}

struct ContentView: View {
  @State var path = {
    var path = NavigationPath()
//    path.append("A")
//    path.append("B")
//    path.append("C")
//    path.append(CounterDestination(initialCount: 42))
//    path.append(
//      CounterDestination(
//        initialCount: 1_000,
//        fact: FactSheetState(message: "1,000 is the number of words a picture is worth.")
//      )
//    )
    return path
  }()

  var body: some View {
    VStack {
      Button {
        self.randomStackButtonTapped()
      } label: {
        Text("Random stack")
      }
      Button {
//        var count = 0
//        for element in self.path {
//          guard let counter = element as? CounterDestination
//          else { continue }
//          count += counter.initialCount
//        }
//        print(count)
      } label: {
        Text("Sum the counts")
      }
      NavigationStack(path: self.$path) {
        ListView()
          .navigationDestination(for: String.self) { letter in
            ListView()
              .navigationTitle(Text(letter))
          }
          .navigationDestination(for: CounterDestination.self) { destination in
            CounterView(
              count: destination.initialCount,
              fact: destination.fact
            )
//            ListView()
//              .navigationTitle(Text("\(number)"))
          }
          .navigationTitle("Root")
      }
      .onChange(of: self.path) { path in
        dump(path)
      }
    }
  }

  func randomStackButtonTapped() {
    self.path = NavigationPath()
    for _ in 0...Int.random(in: 3...6) {
      if Bool.random() {
        self.path.append(Int.random(in: 1...1_000))
      } else {
        self.path.append(
          String(
            Character(
              UnicodeScalar(
                UInt32.random(
                  in: "A".unicodeScalars.first!.value..."Z".unicodeScalars.first!.value
                )
              )!
            )
          )
        )
      }
    }
  }
}



struct CounterView: View {
  @State var count = 0
  @State var fact: FactSheetState?

  var body: some View {
    List {
      HStack {
        Button("-") { self.count -= 1 }
        Text("\(self.count)")
        Button("+") { self.count += 1 }
      }
      .buttonStyle(.borderless)

      Button {
        Task { @MainActor in
          let (data, _) = try await URLSession.shared
            .data(from: URL(string: "http://numbersapi.com/\(self.count)")!)
          self.fact = FactSheetState(
            message: String(decoding: data, as: UTF8.self)
          )
        }
      } label: {
        Text("Number fact")
      }
      .buttonStyle(.borderless)

      Section {
        NavigationLink(value: "A") {
          Text("Go to screen A")
        }
        NavigationLink(value: "B") {
          Text("Go to screen B")
        }
        NavigationLink(value: "C") {
          Text("Go to screen C")
        }
        NavigationLink(value: CounterDestination(initialCount: self.count)) {
          Text("Go to screen \(self.count)")
        }
      }
    }
    .sheet(item: self.$fact) { fact in
      Text(fact.message)
    }
    .navigationTitle(Text("\(self.count)"))
  }
}
struct FactSheetState: Identifiable, Hashable {
  var message = ""
  var id: Self { self }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct ListView: View {
  var body: some View {
    List {
      NavigationLink(value: "A") {
        Text("Go to screen A")
      }
      NavigationLink(value: "B") {
        Text("Go to screen B")
      }
      NavigationLink(value: "C") {
        Text("Go to screen C")
      }
      NavigationLink(value: CounterDestination(initialCount: 42)) {
        Text("Go to screen 42")
      }
    }
  }
}
