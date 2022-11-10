import SwiftUI

//struct CounterDestination: Hashable {
//  var initialCount = 0
//  var fact: FactSheetState?
//}

struct ContentView: View {
  enum Destination: Hashable {
    case counter(CounterModel)
    case letter(String)
  }

  @State var path: [Destination] = [
    .letter("A"),
    .letter("B"),
    .letter("C"),
    .counter(CounterModel(count: 42)),
    .counter(CounterModel(count: 1729, fact: FactSheetState(message: "1,729 is a good number."))),
  ]
//  {
//    var path = NavigationPath()
//    path.append("A")
//    path.append("B")
//    path.append("C")
//    path.append(CounterModel(count: 42))
//    path.append(
//      CounterModel(
//        count: 1_000,
//        fact: FactSheetState(message: "1,000 is the number of words a picture is worth.")
//      )
//    )
//    return path
//  }()

  var body: some View {
    VStack {
      Button {
        self.randomStackButtonTapped()
      } label: {
        Text("Random stack")
      }
      Button {
        var count = 0
        for destination in self.path {
          guard case let .counter(counter) = destination
          else { continue }
          count += counter.count
        }
        print("Sum", count)
      } label: {
        Text("Sum the counts")
      }
      NavigationStack(path: self.$path) {
        ListView()
          .navigationDestination(for: Destination.self) { destination in
            switch destination {
            case let .counter(model):
              CounterView(model: model)
            case let .letter(letter):
              ListView()
                .navigationTitle(Text(letter))
            }
          }
//          .navigationDestination(for: String.self) { letter in
//            ListView()
//              .navigationTitle(Text(letter))
//          }
//          .navigationDestination(for: CounterModel.self) { model in
//            CounterView(model: model)
////            ListView()
////              .navigationTitle(Text("\(number)"))
//          }
          .navigationTitle("Root")
      }
      .onChange(of: self.path) { path in
        dump(path)
      }
    }
  }

  func randomStackButtonTapped() {
    self.path = []
    for _ in 0...Int.random(in: 3...6) {
      if Bool.random() {
        self.path.append(.counter(CounterModel(count: Int.random(in: 1...1_000))))
      } else {
        self.path.append(
          .letter(
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
        )
      }
    }
  }
}

class CounterModel: ObservableObject, Hashable {
  @Published var count = 0
  @Published var fact: FactSheetState?

  init(
    count: Int = 0,
    fact: FactSheetState? = nil
  ) {
    self.count = count
    self.fact = fact
  }

  func decrementButtonTapped() {
    self.count -= 1
  }
  func incrementButtonTapped() {
    self.count += 1
  }
  func factButtonTapped() {
    Task { @MainActor in
      let (data, _) = try await URLSession.shared
        .data(from: URL(string: "http://numbersapi.com/\(self.count)")!)
      self.fact = FactSheetState(
        message: String(decoding: data, as: UTF8.self)
      )
    }
  }

  static func == (lhs: CounterModel, rhs: CounterModel) -> Bool {
    lhs === rhs
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }
}

struct CounterView: View {
  @ObservedObject var model: CounterModel
//  @StateObject var model = CounterModel()

  var body: some View {
    List {
      HStack {
        Button("-") { self.model.decrementButtonTapped() }
        Text("\(self.model.count)")
        Button("+") { self.model.incrementButtonTapped() }
      }
      .buttonStyle(.borderless)

      Button {
        self.model.factButtonTapped()
      } label: {
        Text("Number fact")
      }
      .buttonStyle(.borderless)

      Section {
        NavigationLink(value: ContentView.Destination.letter("A")) {
          Text("Go to screen A")
        }
        NavigationLink(value: ContentView.Destination.letter("B")) {
          Text("Go to screen B")
        }
        NavigationLink(value: ContentView.Destination.letter("C")) {
          Text("Go to screen C")
        }
        NavigationLink(value: ContentView.Destination.counter(CounterModel(count: self.model.count))) {
          Text("Go to screen \(self.model.count)")
        }
      }
    }
    .sheet(item: self.$model.fact) { fact in
      Text(fact.message)
    }
    .navigationTitle(Text("\(self.model.count)"))
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
      NavigationLink(value: ContentView.Destination.letter("A")) {
        Text("Go to screen A")
      }
      NavigationLink(value: ContentView.Destination.letter("B")) {
        Text("Go to screen B")
      }
      NavigationLink(value: ContentView.Destination.letter("C")) {
        Text("Go to screen C")
      }
      NavigationLink(value: ContentView.Destination.counter(CounterModel(count: 42))) {
        Text("Go to screen 42")
      }
    }
  }
}
