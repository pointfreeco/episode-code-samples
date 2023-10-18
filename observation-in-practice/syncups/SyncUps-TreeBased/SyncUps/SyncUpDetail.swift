import Clocks
import CustomDump
import Dependencies
import SwiftUI
import SwiftUINavigation
import XCTestDynamicOverlay

@MainActor
class SyncUpDetailModel: ObservableObject {
  @Published var destination: Destination? {
    didSet { self.bind() }
  }
  @Published var isDismissed = false
  @Published var syncUp: SyncUp

  @Dependency(\.continuousClock) var clock
  @Dependency(\.date.now) var now
  @Dependency(\.openSettings) var openSettings
  @Dependency(\.speechClient.authorizationStatus) var authorizationStatus
  @Dependency(\.uuid) var uuid

  var onConfirmDeletion: () -> Void = unimplemented("SyncUpDetailModel.onConfirmDeletion")

  enum Destination {
    case alert(AlertState<AlertAction>)
    case edit(SyncUpFormModel)
    case meeting(Meeting)
    case record(RecordMeetingModel)
  }
  enum AlertAction {
    case confirmDeletion
    case continueWithoutRecording
    case openSettings
  }

  init(
    destination: Destination? = nil,
    syncUp: SyncUp
  ) {
    self.destination = destination
    self.syncUp = syncUp
    self.bind()
  }

  func deleteMeetings(atOffsets indices: IndexSet) {
    self.syncUp.meetings.remove(atOffsets: indices)
  }

  func meetingTapped(_ meeting: Meeting) {
    self.destination = .meeting(meeting)
  }

  func deleteButtonTapped() {
    self.destination = .alert(.deleteSyncUp)
  }

  func alertButtonTapped(_ action: AlertAction?) async {
    switch action {
    case .confirmDeletion?:
      self.onConfirmDeletion()
      self.isDismissed = true

    case .continueWithoutRecording?:
      self.destination = .record(
        withDependencies(from: self) {
          RecordMeetingModel(syncUp: self.syncUp)
        }
      )

    case .openSettings?:
      await self.openSettings()

    case nil:
      break
    }
  }

  func editButtonTapped() {
    self.destination = .edit(
      withDependencies(from: self) {
        SyncUpFormModel(syncUp: self.syncUp)
      }
    )
  }

  func cancelEditButtonTapped() {
    self.destination = nil
  }

  func doneEditingButtonTapped() {
    guard case let .edit(model) = self.destination
    else { return }

    self.syncUp = model.syncUp
    self.destination = nil
  }

  func startMeetingButtonTapped() {
    switch self.authorizationStatus() {
    case .notDetermined, .authorized:
      self.destination = .record(
        withDependencies(from: self) {
          RecordMeetingModel(syncUp: self.syncUp)
        }
      )

    case .denied:
      self.destination = .alert(.speechRecognitionDenied)

    case .restricted:
      self.destination = .alert(.speechRecognitionRestricted)

    @unknown default:
      break
    }
  }

  private func bind() {
    switch destination {
    case let .record(recordMeetingModel):
      recordMeetingModel.onMeetingFinished = { [weak self] transcript async in
        guard let self else { return }

        let didCancel = nil == (try? await self.clock.sleep(for: .milliseconds(400)))
        withAnimation(didCancel ? nil : .default) {
          self.syncUp.meetings.insert(
            Meeting(
              id: Meeting.ID(self.uuid()),
              date: self.now,
              transcript: transcript
            ),
            at: 0
          )
          self.destination = nil
        }
      }

    case .edit, .meeting, .alert, .none:
      break
    }
  }
}

struct SyncUpDetailView: View {
  @Environment(\.dismiss) var dismiss
  @ObservedObject var model: SyncUpDetailModel

  var body: some View {
    List {
      Section {
        Button {
          self.model.startMeetingButtonTapped()
        } label: {
          Label("Start Meeting", systemImage: "timer")
            .font(.headline)
            .foregroundColor(.accentColor)
        }
        HStack {
          Label("Length", systemImage: "clock")
          Spacer()
          Text(self.model.syncUp.duration.formatted(.units()))
        }

        HStack {
          Label("Theme", systemImage: "paintpalette")
          Spacer()
          Text(self.model.syncUp.theme.name)
            .padding(4)
            .foregroundColor(self.model.syncUp.theme.accentColor)
            .background(self.model.syncUp.theme.mainColor)
            .cornerRadius(4)
        }
      } header: {
        Text("Sync-up Info")
      }

      if !self.model.syncUp.meetings.isEmpty {
        Section {
          ForEach(self.model.syncUp.meetings) { meeting in
            Button {
              self.model.meetingTapped(meeting)
            } label: {
              HStack {
                Image(systemName: "calendar")
                Text(meeting.date, style: .date)
                Text(meeting.date, style: .time)
              }
            }
          }
          .onDelete { indices in
            self.model.deleteMeetings(atOffsets: indices)
          }
        } header: {
          Text("Past meetings")
        }
      }

      Section {
        ForEach(self.model.syncUp.attendees) { attendee in
          Label(attendee.name, systemImage: "person")
        }
      } header: {
        Text("Attendees")
      }

      Section {
        Button("Delete") {
          self.model.deleteButtonTapped()
        }
        .foregroundColor(.red)
        .frame(maxWidth: .infinity)
      }
    }
    .navigationTitle(self.model.syncUp.title)
    .toolbar {
      Button("Edit") {
        self.model.editButtonTapped()
      }
    }
    .navigationDestination(
      unwrapping: self.$model.destination,
      case: /SyncUpDetailModel.Destination.meeting
    ) { $meeting in
      MeetingView(meeting: meeting, syncUp: self.model.syncUp)
    }
    .navigationDestination(
      unwrapping: self.$model.destination,
      case: /SyncUpDetailModel.Destination.record
    ) { $model in
      RecordMeetingView(model: model)
    }
    .alert(
      unwrapping: self.$model.destination,
      case: /SyncUpDetailModel.Destination.alert
    ) { action in
      await self.model.alertButtonTapped(action)
    }
    .sheet(
      unwrapping: self.$model.destination,
      case: /SyncUpDetailModel.Destination.edit
    ) { $editModel in
      NavigationStack {
        SyncUpFormView(model: editModel)
          .navigationTitle(self.model.syncUp.title)
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                self.model.cancelEditButtonTapped()
              }
            }
            ToolbarItem(placement: .confirmationAction) {
              Button("Done") {
                self.model.doneEditingButtonTapped()
              }
            }
          }
      }
    }
    .onChange(of: self.model.isDismissed) { _, _ in self.dismiss() }
  }
}

extension AlertState where Action == SyncUpDetailModel.AlertAction {
  static let deleteSyncUp = Self {
    TextState("Delete?")
  } actions: {
    ButtonState(role: .destructive, action: .confirmDeletion) {
      TextState("Yes")
    }
    ButtonState(role: .cancel) {
      TextState("Nevermind")
    }
  } message: {
    TextState("Are you sure you want to delete this meeting?")
  }

  static let speechRecognitionDenied = Self {
    TextState("Speech recognition denied")
  } actions: {
    ButtonState(action: .continueWithoutRecording) {
      TextState("Continue without recording")
    }
    ButtonState(action: .openSettings) {
      TextState("Open settings")
    }
    ButtonState(role: .cancel) {
      TextState("Cancel")
    }
  } message: {
    TextState("""
      You previously denied speech recognition and so your meeting meeting will not be \
      recorded. You can enable speech recognition in settings, or you can continue without \
      recording.
      """)
  }

  static let speechRecognitionRestricted = Self {
    TextState("Speech recognition restricted")
  } actions: {
    ButtonState(action: .continueWithoutRecording) {
      TextState("Continue without recording")
    }
    ButtonState(role: .cancel) {
      TextState("Cancel")
    }
  } message: {
    TextState("""
      Your device does not support speech recognition and so your meeting will not be recorded.
      """)
  }
}

struct MeetingView: View {
  let meeting: Meeting
  let syncUp: SyncUp

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Divider()
          .padding(.bottom)
        Text("Attendees")
          .font(.headline)
        ForEach(self.syncUp.attendees) { attendee in
          Text(attendee.name)
        }
        Text("Transcript")
          .font(.headline)
          .padding(.top)
        Text(self.meeting.transcript)
      }
    }
    .navigationTitle(Text(self.meeting.date, style: .date))
    .padding()
  }
}

struct SyncUpDetail_Previews: PreviewProvider {
  static var previews: some View {
    Preview(
      message: """
        This preview demonstrates the "happy path" of the application where everything works \
        perfectly. You can start a meeting, wait a few moments, end the meeting, and you will \
        see that a new transcription was added to the past meetings. The transcript will consist \
        of some "lorem ipsum" text because a mock speech recongizer is used for Xcode previews.
        """
    ) {
      NavigationStack {
        SyncUpDetailView(model: SyncUpDetailModel(syncUp: .mock))
      }
    }
    .previewDisplayName("Happy path")

    Preview(
      message: """
        This preview demonstrates an "unhappy path" of the application where the speech \
        recognizer mysteriously fails after 2 seconds of recording. This gives us an opportunity \
        to see how the application deals with this rare occurence. To see the behavior, run the \
        preview, tap the "Start Meeting" button and wait 2 seconds.
        """
    ) {
      NavigationStack {
        SyncUpDetailView(
          model: withDependencies {
            $0.speechClient = .fail(after: .seconds(2))
          } operation: {
            SyncUpDetailModel(syncUp: .mock)
          }
        )
      }
    }
    .previewDisplayName("Speech recognition failed")

    Preview(
      message: """
        This preview demonstrates how the feature behaves when access to speech recognition has \
        been previously denied by the user. Tap the "Start Meeting" button to see how we handle \
        that situation.
        """
    ) {
      NavigationStack {
        SyncUpDetailView(
          model: withDependencies {
            $0.speechClient.authorizationStatus = { .denied }
          } operation: {
            SyncUpDetailModel(syncUp: .mock)
          }
        )
      }
    }
    .previewDisplayName("Speech recognition denied")

    Preview(
      message: """
        This preview demonstrates how the feature behaves when the device restricts access to \
        speech recognition APIs. Tap the "Start Meeting" button to see how we handle that \
        situation.
        """
    ) {
      NavigationStack {
        SyncUpDetailView(
          model: withDependencies {
            $0.speechClient.authorizationStatus = { .restricted }
          } operation: {
            SyncUpDetailModel(syncUp: .mock)
          }
        )
      }
    }
    .previewDisplayName("Speech recognition restricted")
  }
}
