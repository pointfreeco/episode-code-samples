import Counter
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

        Button(model.isTimerRunning ? "Stop timer" : "Start timer") {
          model.toggleTimerButtonTapped()
        }

        Section {
          ForEach(model.savedFacts, id: \.self) { fact in
            HStack {
              Text(fact)
              Spacer()
              Button("Delete") {
                model.deleteFactButtonTapped(fact: fact)
              }
            }
          }
        } header: {
          Text("Saved facts")
        }
      }
      .disabled(model.factIsLoading)
      .alert($model.alert) { action in
        guard let action else { return }
        model.handle(alertAction: action)
      }
    }
  }
}

#Preview("SwiftUI") {
  NavigationStack {
    CounterView(model: CounterModel())
  }
}
