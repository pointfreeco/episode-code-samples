import Combine
import Dependencies
import SwiftUI

@MainActor
@Observable
class AppModel {
  var path: [Destination] {
    didSet { self.bind() }
  }
  var syncUpsList: SyncUpsListModel {
    didSet { self.bind() }
  }

  @ObservationIgnored
  @Dependency(\.continuousClock) var clock
  @ObservationIgnored
  @Dependency(\.date.now) var now
  @ObservationIgnored
  @Dependency(\.uuid) var uuid

  private var detailCancellable: AnyCancellable?

  enum Destination: Hashable {
    case detail(SyncUpDetailModel)
    case meeting(Meeting, syncUp: SyncUp)
    case record(RecordMeetingModel)
  }

  init(
    path: [Destination] = [],
    syncUpsList: SyncUpsListModel
  ) {
    self._path = path
    self._syncUpsList = syncUpsList
    self.bind()
  }

  private func bind() {
    self._syncUpsList.onSyncUpTapped = { [weak self] syncUp in
      guard let self else { return }
      withDependencies(from: self) {
        self.path.append(.detail(SyncUpDetailModel(syncUp: syncUp)))
      }
    }

    for destination in self._path {
      switch destination {
      case let .detail(detailModel):
        self.bindDetail(model: detailModel)

      case .meeting:
        break

      case let .record(recordModel):
        self.bindRecord(model: recordModel)
      }
    }
  }

  private func bindDetail(model: SyncUpDetailModel) {
    model.onMeetingStarted = { [weak self] syncUp in
      guard let self else { return }
      withDependencies(from: self) {
        self.path.append(
          .record(
            RecordMeetingModel(syncUp: syncUp)
          )
        )
      }
    }

    model.onConfirmDeletion = { [weak model, weak self] in
      guard let model else { return }
      self?.syncUpsList.syncUps.remove(id: model.syncUp.id)
      self?.path.removeLast()
    }

    model.onMeetingTapped = { [weak model, weak self] meeting in
      guard let model else { return }
      self?.path.append(.meeting(meeting, syncUp: model.syncUp))
    }

    model.onSyncUpUpdated = { [weak self] syncUp in
      self?.syncUpsList.syncUps[id: syncUp.id] = syncUp
    }
//    self.detailCancellable = model.$syncUp
//      .sink { [weak self] syncUp in
//        self?.syncUpsList.syncUps[id: syncUp.id] = syncUp
//      }
  }

  private func bindRecord(model: RecordMeetingModel) {
    model.onMeetingFinished = { [weak self] transcript in
      guard let self else { return }

      guard
        case let .some(.detail(detailModel)) = self.path.dropLast().last
      else {
        return
      }

      let meeting = Meeting(
        id: Meeting.ID(self.uuid()),
        date: self.now,
        transcript: transcript
      )

      let didCancel = (try? await self.clock.sleep(for: .milliseconds(400))) == nil
      _ = withAnimation(didCancel ? nil : .default) {
        detailModel.syncUp.meetings.insert(meeting, at: 0)
      }
    }
  }
}

struct AppView: View {
  @Bindable var model: AppModel

  var body: some View {
    NavigationStack(path: self.$model.path) {
      SyncUpsList(model: self.model.syncUpsList)
        .navigationDestination(for: AppModel.Destination.self) { destination in
          switch destination {
          case let .detail(detailModel):
            SyncUpDetailView(model: detailModel)
          case let .meeting(meeting, syncUp: syncUp):
            MeetingView(meeting: meeting, syncUp: syncUp)
          case let .record(recordModel):
            RecordMeetingView(model: recordModel)
          }
        }
    }
  }
}

struct App_Previews: PreviewProvider {
  static var previews: some View {
    AppView(
      model: withDependencies {
        $0.dataManager = .mock(
          initialData: try! JSONEncoder().encode([
            SyncUp.mock,
            .engineeringMock,
            .designMock,
          ])
        )
      } operation: {
        AppModel(syncUpsList: SyncUpsListModel())
      }
    )
    .previewDisplayName("Happy path")

    Preview(
      message: """
        The preview demonstrates how you can start the application navigated to a very specific \
        screen just by constructing a piece of state. In particular we will start the app drilled \
        down to the detail screen of a sync-up, and then further drilled down to the record screen \
        for a new meeting.
        """
    ) {
      AppView(
        model: withDependencies {
          $0.dataManager = .mock(
            initialData: try! JSONEncoder().encode([
              SyncUp.mock,
              .engineeringMock,
              .designMock,
            ])
          )
        } operation: {
          AppModel(
            path: [
              .detail(SyncUpDetailModel(syncUp: .mock)),
              .record(RecordMeetingModel(syncUp: .mock)),
            ],
            syncUpsList: SyncUpsListModel()
          )
        }
      )
    }
    .previewDisplayName("Deep link record flow")
  }
}
