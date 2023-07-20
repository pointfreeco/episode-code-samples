import ComposableArchitecture
import SwiftUI

struct StandupFormFeature: Reducer {
  struct State: Equatable {
    @BindingState var focus: Field?
    @BindingState var standup: Standup

    enum Field: Hashable {
      case attendee(Attendee.ID)
      case title
    }

    init(focus: Field? = .title, standup: Standup) {
      self.focus = focus
      self.standup = standup
      if self.standup.attendees.isEmpty {
        self.standup.attendees.append(Attendee(id: UUID()))
      }
    }
  }
  enum Action: BindableAction {
    case addAttendeeButtonTapped
    case binding(BindingAction<State>)
    case deleteAttendees(atOffsets: IndexSet)
  }
  @Dependency(\.uuid) var uuid
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .addAttendeeButtonTapped:
        let id = self.uuid()
        state.standup.attendees.append(Attendee(id: id))
        state.focus = .attendee(id)
        return .none

      case .binding(_):
        return .none

      case let .deleteAttendees(atOffsets: indices):
        state.standup.attendees.remove(atOffsets: indices)
        if state.standup.attendees.isEmpty {
          state.standup.attendees.append(Attendee(id: self.uuid()))
        }
        guard let firstIndex = indices.first
        else { return .none }
        let index = min(firstIndex, state.standup.attendees.count - 1)
        state.focus = .attendee(state.standup.attendees[index].id)
        return .none
      }
    }
  }
}

struct StandupFormView: View {
  let store: StoreOf<StandupFormFeature>
  @FocusState var focus: StandupFormFeature.State.Field?

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Section {
          TextField("Title", text: viewStore.$standup.title)
            .focused(self.$focus, equals: .title)
          HStack {
            Slider(value: viewStore.$standup.duration.minutes, in: 5...30, step: 1) {
              Text("Length")
            }
            Spacer()
            Text(viewStore.standup.duration.formatted(.units()))
          }
          ThemePicker(selection: viewStore.$standup.theme)
        } header: {
          Text("Standup Info")
        }
        Section {
          ForEach(viewStore.$standup.attendees) { $attendee in
            TextField("Name", text: $attendee.name)
              .focused(self.$focus, equals: .attendee(attendee.id))
          }
          .onDelete { indices in
            viewStore.send(.deleteAttendees(atOffsets: indices))
          }
          
          Button("Add attendee") {
            viewStore.send(.addAttendeeButtonTapped)
          }
        } header: {
          Text("Attendees")
        }
      }
      .bind(viewStore.$focus, to: self.$focus)
    }
  }
}

extension Duration {
  fileprivate var minutes: Double {
    get { Double(self.components.seconds / 60) }
    set { self = .seconds(newValue * 60) }
  }
}

struct ThemePicker: View {
  @Binding var selection: Theme

  var body: some View {
    Picker("Theme", selection: self.$selection) {
      ForEach(Theme.allCases) { theme in
        ZStack {
          RoundedRectangle(cornerRadius: 4)
            .fill(theme.mainColor)
          Label(theme.name, systemImage: "paintpalette")
            .padding(4)
        }
        .foregroundColor(theme.accentColor)
        .fixedSize(horizontal: false, vertical: true)
        .tag(theme)
      }
    }
  }
}

#Preview {
  MainActor.assumeIsolated {
    NavigationStack {
      StandupFormView(
        store: Store(initialState: StandupFormFeature.State(standup: .mock)) {
          StandupFormFeature()
        }
      )
    }
  }
}
