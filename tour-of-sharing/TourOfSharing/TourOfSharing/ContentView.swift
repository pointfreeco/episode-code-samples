import Sharing
import SwiftUI

struct ManyCountersView: View {
  @Shared(.appStorage("count")) var count = 0

  var body: some View {
    Form {
      Section {
        CounterView()
      } header: {
        Text("@Shared in an observable model")
      }

      Section {
        AnotherCounterView()
      } header: {
        Text("@Shared in a view")
      }

      Section {
        AppStorageCounterView()
      } header: {
        Text("@AppStorage")
      }

      Section {
        CounterViewController.Representable()
      } header: {
        Text("@Shared in a view controller")
      }

      Button(#"UserDefaults.set(0, "count")"#) {
        UIView.animate(withDuration: 0.35) {
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
    HStack {
      Text("\(model.count)")
        .font(.largeTitle)
      Button("Decrement") {
        model.$count.withLock { $0 -= 1 }
      }
      Button("Increment") {
        model.$count.withLock { $0 += 1 }
      }
    }
    .buttonStyle(.borderless)
  }
}

struct AnotherCounterView: View {
  @Shared(.appStorage("count")) var count = 0

  var body: some View {
    HStack {
      Text("\(count)")
        .font(.largeTitle)
      Button("Decrement") {
        $count.withLock { $0 -= 1 }
      }
      Button("Increment") {
        $count.withLock { $0 += 1 }
      }
    }
    .buttonStyle(.borderless)
  }
}

struct AppStorageCounterView: View {
  @AppStorage("count") var count = 0

  var body: some View {
    HStack {
      Text("\(count)")
        .font(.largeTitle)
      Button("Decrement") {
        count -= 1
      }
      Button("Increment") {
        count += 1
      }
    }
    .buttonStyle(.borderless)
  }
}

#Preview("CounterView") {
  CounterView()
}

#Preview("ManyCountersView") {
  ManyCountersView()
}

import Combine

final class CounterViewController: UIViewController {
  @Shared(.appStorage("count")) var count = 0
  var cancellables: Set<AnyCancellable> = []

  struct Representable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CounterViewController {
      CounterViewController()
    }
    func updateUIViewController(_ uiViewController: CounterViewController, context: Context) {
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillProportionally
    stackView.spacing = 8
    view.addSubview(stackView)

    let countLabel = UILabel()
    countLabel.textColor = .black
    countLabel.font = .preferredFont(forTextStyle: .largeTitle)
    stackView.addArrangedSubview(countLabel)

    let decrementButton = UIButton(type: .system)
    decrementButton.setTitle("Decrement", for: .normal)
    decrementButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
    decrementButton.addAction(
      UIAction { [$count] _ in
        $count.withLock { $0 -= 1 }
      },
      for: .touchUpInside
    )
    stackView.addArrangedSubview(decrementButton)

    let incrementButton = UIButton(type: .system)
    incrementButton.setTitle("Increment", for: .normal)
    incrementButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
    incrementButton.addAction(
      UIAction { [$count] _ in
        $count.withLock { $0 += 1 }
      },
      for: .touchUpInside
    )
    stackView.addArrangedSubview(incrementButton)

    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.heightAnchor.constraint(equalToConstant: 300)
    ])

    $count.publisher
      .sink {
        countLabel.text = $0.description
      }
      .store(in: &cancellables)

//    observe { [weak self] in
//      guard let self else { return }
//      countLabel.text = count.description
//    }
  }
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
