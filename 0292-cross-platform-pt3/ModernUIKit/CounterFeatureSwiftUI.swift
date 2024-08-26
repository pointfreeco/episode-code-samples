import Perception
import SwiftUI
import SwiftUINavigation

struct CounterView: View {
  @Perception.Bindable var model: CounterModel
  var body: some View {
    WithPerceptionTracking {
      Form {
        Stepper(
          "\(model.count)",
          value: $model.count
        )
        if model.factIsLoading {
          ProgressView().id(UUID())
        }

        Button("Get fact") {
          Task {
            await model.factButtonTapped()
          }
        }
      }
      .disabled(model.factIsLoading)
      .sheet(item: $model.fact) { fact in
        Text(fact.value)
      }
    }
  }
}

#Preview("SwiftUI") {
  NavigationStack {
    CounterView(model: CounterModel())
  }
}
