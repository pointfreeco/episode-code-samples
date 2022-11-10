import SwiftUI

//struct CounterDestination: Hashable {
//  var initialCount = 0
//  var fact: FactSheetState?
//}

class AppModel: ObservableObject {
  @Published var path: [Destination] {
    didSet {
      self.bind()
    }
  }

  init(path: [Destination] = []) {
    self.path = path
    self.bind()
  }

  enum Destination: Hashable {
    case counter(CounterModel)
    case letter(String)
  }

  func bind() {
    for destination in self.path {
      switch destination {
      case let .counter(model):
        model.onTapLetter = { [weak self] letter in
          guard let self else { return }
          self.path.append(.letter(letter))
        }
        model.onTapNumber = { [weak self] number in
          guard let self else { return }
          self.path.append(.counter(CounterModel(count: number)))
        }

      case .letter:
        break
      }
    }
  }
}

struct ContentView: View {
  @ObservedObject var model: AppModel
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
        for destination in self.model.path {
          guard case let .counter(counter) = destination
          else { continue }
          count += counter.count
        }
        print("Sum", count)
      } label: {
        Text("Sum the counts")
      }
      NavigationStack(path: self.$model.path) {
        ListView()
          .navigationDestination(for: AppModel.Destination.self) { destination in
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
      .onChange(of: self.model.path) { path in
        dump(path)
      }
    }
  }

  func randomStackButtonTapped() {
    self.model.path = []
    for _ in 0...Int.random(in: 3...6) {
      if Bool.random() {
        self.model.path.append(.counter(CounterModel(count: Int.random(in: 1...1_000))))
      } else {
        self.model.path.append(
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

  var onTapNumber: (Int) -> Void = { _ in }
  var onTapLetter: (String) -> Void = { _ in }

  init(
    count: Int = 0,
    fact: FactSheetState? = nil
  ) {
    self.count = count
    self.fact = fact
  }

  func numberButtonTapped(number: Int) {
    self.onTapNumber(number)
  }

  func letterButtonTapped(letter: String) {
    self.onTapLetter(letter)
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
        Button {
          self.model.letterButtonTapped(letter: "A")
        } label: {
          Text("Go to screen A")
        }
        Button {
          self.model.letterButtonTapped(letter: "B")
        } label: {
          Text("Go to screen B")
        }
        Button {
          self.model.letterButtonTapped(letter: "C")
        } label: {
          Text("Go to screen C")
        }
        Button {
          self.model.numberButtonTapped(number: self.model.count)
        } label: {
          Text("Go to screen \(self.model.count)")
        }
//        .buttonStyle(.navigationLink)

//        NavigationLink(value: ContentView.Destination.letter("A")) {
//          Text("Go to screen A")
//        }
//        NavigationLink(value: ContentView.Destination.letter("B")) {
//          Text("Go to screen B")
//        }
//        NavigationLink(value: ContentView.Destination.letter("C")) {
//          Text("Go to screen C")
//        }
//        NavigationLink(value: ContentView.Destination.counter(CounterModel(count: self.model.count))) {
//          Text("Go to screen \(self.model.count)")
//        }
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
    ContentView(model: AppModel())
  }
}

struct ListView: View {
  var body: some View {
    List {
      NavigationLink(value: AppModel.Destination.letter("A")) {
        Text("Go to screen A")
      }
      NavigationLink(value: AppModel.Destination.letter("B")) {
        Text("Go to screen B")
      }
      NavigationLink(value: AppModel.Destination.letter("C")) {
        Text("Go to screen C")
      }
      NavigationLink(value: AppModel.Destination.counter(CounterModel(count: 42))) {
        Text("Go to screen 42")
      }
    }
  }
}
