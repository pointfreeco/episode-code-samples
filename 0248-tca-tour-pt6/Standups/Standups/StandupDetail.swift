import ComposableArchitecture
import SwiftUI

struct StandupDetailFeature: Reducer {
  struct State: Equatable {
    @PresentationState var destination: Destination.State?
    var standup: Standup
  }
  enum Action: Equatable {
    case cancelEditStandupButtonTapped
    case delegate(Delegate)
    case deleteButtonTapped
    case deleteMeetings(atOffsets: IndexSet)
    case destination(PresentationAction<Destination.Action>)
    case editButtonTapped
    case saveStandupButtonTapped
    enum Delegate: Equatable {
      case deleteStandup(id: Standup.ID)
      case standupUpdated(Standup)
    }
  }
  @Dependency(\.dismiss) var dismiss

  // @Environment(\.dismiss) var dismiss

  struct Destination: Reducer {
    enum State: Equatable {
      case alert(AlertState<Action.Alert>)
      case editStandup(StandupFormFeature.State)
    }
    enum Action: Equatable {
      case alert(Alert)
      case editStandup(StandupFormFeature.Action)
      enum Alert {
        case confirmDeletion
      }
    }
    var body: some ReducerOf<Self> {
      Scope(state: /State.editStandup, action: /Action.editStandup) {
        StandupFormFeature()
      }
    }
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .cancelEditStandupButtonTapped:
        state.destination = nil
        return .none

      case .delegate:
        return .none

      case .deleteButtonTapped:
        state.destination = .alert(
          AlertState {
            TextState("Are you sure you want to delete?")
          } actions: {
            ButtonState(role: .destructive, action: .confirmDeletion) {
              TextState("Delete")
            }
          }
        )
        return .none

      case .deleteMeetings(atOffsets: let indices):
        state.standup.meetings.remove(atOffsets: indices)
        return .none

      case .destination(.presented(.alert(.confirmDeletion))):
        // TODO: Delete this standup
        return .run { [id = state.standup.id] send in
          await send(.delegate(.deleteStandup(id: id)))
          await self.dismiss()
        }

      case .destination:
        return .none

      case .editButtonTapped:
        state.destination = .editStandup(StandupFormFeature.State(standup: state.standup))
        return .none
      case .saveStandupButtonTapped:
        guard case let .editStandup(standupForm) = state.destination
        else { return .none }
        state.standup = standupForm.standup
        state.destination = nil
        return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
    .onChange(of: \.standup) { oldValue, newValue in
      Reduce { state, action in
        .send(.delegate(.standupUpdated(newValue)))
      }
    }
  }
}

struct StandupDetailView: View {
  let store: StoreOf<StandupDetailFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      List {
        Section {
          NavigationLink(
            state: AppFeature.Path.State.recordMeeting(RecordMeetingFeature.State(standup: viewStore.standup))
          ) {
            Label("Start Meeting", systemImage: "timer")
              .font(.headline)
              .foregroundColor(.accentColor)
          }
          HStack {
            Label("Length", systemImage: "clock")
            Spacer()
            Text(viewStore.standup.duration.formatted(.units()))
          }

          HStack {
            Label("Theme", systemImage: "paintpalette")
            Spacer()
            Text(viewStore.standup.theme.name)
              .padding(4)
              .foregroundColor(viewStore.standup.theme.accentColor)
              .background(viewStore.standup.theme.mainColor)
              .cornerRadius(4)
          }
        } header: {
          Text("Standup Info")
        }

        if !viewStore.standup.meetings.isEmpty {
          Section {
            ForEach(viewStore.standup.meetings) { meeting in
              NavigationLink {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Do something@*//*@END_MENU_TOKEN@*/
              } label: {
                HStack {
                  Image(systemName: "calendar")
                  Text(meeting.date, style: .date)
                  Text(meeting.date, style: .time)
                }
              }
            }
            .onDelete { indices in
              viewStore.send(.deleteMeetings(atOffsets: indices))
            }
          } header: {
            Text("Past meetings")
          }
        }

        Section {
          ForEach(viewStore.standup.attendees) { attendee in
            Label(attendee.name, systemImage: "person")
          }
        } header: {
          Text("Attendees")
        }

        Section {
          Button("Delete") {
            viewStore.send(.deleteButtonTapped)
          }
          .foregroundColor(.red)
          .frame(maxWidth: .infinity)
        }
      }
      .navigationTitle(viewStore.standup.title)
      .toolbar {
        Button("Edit") {
          viewStore.send(.editButtonTapped)
        }
      }
      .alert(
        store: self.store.scope(state: \.$destination, action: { .destination($0) }),
        state: /StandupDetailFeature.Destination.State.alert,
        action: StandupDetailFeature.Destination.Action.alert
      )
      .sheet(
        store: self.store.scope(state: \.$destination, action: { .destination($0) }),
        state: /StandupDetailFeature.Destination.State.editStandup,
        action: StandupDetailFeature.Destination.Action.editStandup
      ) { store in
        NavigationStack {
          StandupFormView(store: store)
            .navigationTitle("Edit standup")
            .toolbar {
              ToolbarItem {
                Button("Save") { viewStore.send(.saveStandupButtonTapped) }
              }
              ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { viewStore.send(.cancelEditStandupButtonTapped) }
              }
            }
        }
      }
    }
  }
}

#Preview {
  MainActor.assumeIsolated {
    NavigationStack {
      StandupDetailView(
        store: Store(initialState: StandupDetailFeature.State(standup: .mock)) {
          StandupDetailFeature()
            ._printChanges()
        }
      )
    }
  }
}
