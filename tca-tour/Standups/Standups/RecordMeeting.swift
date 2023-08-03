import ComposableArchitecture
import Speech
import SwiftUI

struct RecordMeetingFeature: Reducer {
  struct State: Equatable {
    @PresentationState var alert: AlertState<Action.Alert>?
    var secondsElapsed = 0
    var speakerIndex = 0
    let standup: Standup
    var transcript = ""

    var durationRemaining: Duration {
      self.standup.duration - .seconds(self.secondsElapsed)
    }
  }
  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case delegate(Delegate)
    case endMeetingButtonTapped
    case nextButtonTapped
    case onTask
    case speechResult(String)
    case timerTicked
    enum Alert {
      case confirmDiscard
      case confirmSave
    }
    enum Delegate: Equatable {
      case saveMeeting(transcript: String)
    }
  }
  @Dependency(\.continuousClock) var clock
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.speechClient) var speechClient
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .alert(.presented(.confirmDiscard)):
        return .run { send in
          //await send(.delegate(.saveMeeting))
          await self.dismiss()
        }

      case .alert(.presented(.confirmSave)):
        return .run { [transcript = state.transcript] send in
          await send(.delegate(.saveMeeting(transcript: transcript)))
          await self.dismiss()
        }

      case .alert(.dismiss):
        return .none

      case .delegate:
        return .none

      case .endMeetingButtonTapped:
        state.alert = .endMeeting(isDiscardable: true)
        return .none

      case .nextButtonTapped:
        guard state.speakerIndex < state.standup.attendees.count - 1
        else {
          state.alert = .endMeeting(isDiscardable: false)
          return .none
        }
        state.speakerIndex += 1
        state.secondsElapsed =
        state.speakerIndex * Int(state.standup.durationPerAttendee.components.seconds)
        return .none

      case .onTask:
        return .run { send in
          await self.onTask(send: send)
        }

      case let .speechResult(transcript):
        state.transcript = transcript
        return .none

      case .timerTicked:
        guard state.alert == nil
        else { return .none }
        
        state.secondsElapsed += 1
        let secondsPerAttendee = Int(state.standup.durationPerAttendee.components.seconds)
          if state.secondsElapsed.isMultiple(of: secondsPerAttendee) {
            if state.speakerIndex == state.standup.attendees.count - 1 {
              return .run { [transcript = state.transcript] send in
                await send(.delegate(.saveMeeting(transcript: transcript)))
                await self.dismiss()
              }
            }
            state.speakerIndex += 1
          }
        return .none
      }
    }
    .ifLet(\.$alert, action: /Action.alert)
  }

  private func onTask(send: Send<Action>) async {
    await withTaskGroup(of: Void.self) { group in
      group.addTask {
        let status = await self.speechClient.requestAuthorization()

        if status == .authorized {
          do {
            for try await transcript in self.speechClient.start() {
              await send(.speechResult(transcript))
            }
          } catch {
            // TODO: Handle error
          }
        }
      }

      group.addTask {
        for await _ in self.clock.timer(interval: .seconds(1)) {
          await send(.timerTicked)
        }
      }
    }
  }
}

extension AlertState where Action == RecordMeetingFeature.Action.Alert {
  static func endMeeting(isDiscardable: Bool) -> Self {
    Self {
      TextState("End meeting?")
    } actions: {
      ButtonState(action: .confirmSave) {
        TextState("Save and end")
      }
      if isDiscardable {
        ButtonState(role: .destructive, action: .confirmDiscard) {
          TextState("Discard")
        }
      }
      ButtonState(role: .cancel) {
        TextState("Resume")
      }
    } message: {
      TextState("You are ending the meeting early. What would you like to do?")
    }
  }
}

struct RecordMeetingView: View {
  let store: StoreOf<RecordMeetingFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack {
        RoundedRectangle(cornerRadius: 16)
          .fill(viewStore.standup.theme.mainColor)

        VStack {
          MeetingHeaderView(
            secondsElapsed: viewStore.secondsElapsed,
            durationRemaining: viewStore.durationRemaining,
            theme: viewStore.standup.theme
          )
          MeetingTimerView(
            standup: viewStore.standup,
            speakerIndex: viewStore.speakerIndex
          )
          MeetingFooterView(
            standup: viewStore.standup,
            nextButtonTapped: {
              viewStore.send(.nextButtonTapped)
            },
            speakerIndex: viewStore.speakerIndex
          )
        }
      }
      .padding()
      .foregroundColor(viewStore.standup.theme.accentColor)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("End meeting") {
            viewStore.send(.endMeetingButtonTapped)
          }
        }
      }
      .navigationBarBackButtonHidden(true)
      .task { await viewStore.send(.onTask).finish() }
      .alert(store: self.store.scope(state: \.$alert, action: { .alert($0) }))
    }
  }
}

struct MeetingHeaderView: View {
  let secondsElapsed: Int
  let durationRemaining: Duration
  let theme: Theme

  var body: some View {
    VStack {
      ProgressView(value: self.progress)
        .progressViewStyle(MeetingProgressViewStyle(theme: self.theme))
      HStack {
        VStack(alignment: .leading) {
          Text("Time Elapsed")
            .font(.caption)
          Label(
            Duration.seconds(self.secondsElapsed).formatted(.units()),
            systemImage: "hourglass.bottomhalf.fill"
          )
        }
        Spacer()
        VStack(alignment: .trailing) {
          Text("Time Remaining")
            .font(.caption)
          Label(self.durationRemaining.formatted(.units()), systemImage: "hourglass.tophalf.fill")
            .font(.body.monospacedDigit())
            .labelStyle(.trailingIcon)
        }
      }
    }
    .padding([.top, .horizontal])
  }

  private var totalDuration: Duration {
    .seconds(self.secondsElapsed) + self.durationRemaining
  }

  private var progress: Double {
    guard self.totalDuration > .seconds(0) else { return 0 }
    return Double(self.secondsElapsed) / Double(self.totalDuration.components.seconds)
  }
}

struct MeetingProgressViewStyle: ProgressViewStyle {
  var theme: Theme

  func makeBody(configuration: Configuration) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .fill(self.theme.accentColor)
        .frame(height: 20)

      ProgressView(configuration)
        .tint(self.theme.mainColor)
        .frame(height: 12)
        .padding(.horizontal)
    }
  }
}

struct MeetingTimerView: View {
  let standup: Standup
  let speakerIndex: Int

  var body: some View {
    Circle()
      .strokeBorder(lineWidth: 24)
      .overlay {
        VStack {
          Group {
            if self.speakerIndex < self.standup.attendees.count {
              Text(self.standup.attendees[self.speakerIndex].name)
            } else {
              Text("Someone")
            }
          }
          .font(.title)
          Text("is speaking")
          Image(systemName: "mic.fill")
            .font(.largeTitle)
            .padding(.top)
        }
        .foregroundStyle(self.standup.theme.accentColor)
      }
      .overlay {
        ForEach(Array(self.standup.attendees.enumerated()), id: \.element.id) { index, attendee in
          if index < self.speakerIndex + 1 {
            SpeakerArc(totalSpeakers: self.standup.attendees.count, speakerIndex: index)
              .rotation(Angle(degrees: -90))
              .stroke(self.standup.theme.mainColor, lineWidth: 12)
          }
        }
      }
      .padding(.horizontal)
  }
}

struct SpeakerArc: Shape {
  let totalSpeakers: Int
  let speakerIndex: Int

  func path(in rect: CGRect) -> Path {
    let diameter = min(rect.size.width, rect.size.height) - 24
    let radius = diameter / 2
    let center = CGPoint(x: rect.midX, y: rect.midY)
    return Path { path in
      path.addArc(
        center: center,
        radius: radius,
        startAngle: self.startAngle,
        endAngle: self.endAngle,
        clockwise: false
      )
    }
  }

  private var degreesPerSpeaker: Double {
    360 / Double(self.totalSpeakers)
  }
  private var startAngle: Angle {
    Angle(degrees: self.degreesPerSpeaker * Double(self.speakerIndex) + 1)
  }
  private var endAngle: Angle {
    Angle(degrees: self.startAngle.degrees + self.degreesPerSpeaker - 1)
  }
}

struct MeetingFooterView: View {
  let standup: Standup
  var nextButtonTapped: () -> Void
  let speakerIndex: Int

  var body: some View {
    VStack {
      HStack {
        if self.speakerIndex < self.standup.attendees.count - 1 {
          Text("Speaker \(self.speakerIndex + 1) of \(self.standup.attendees.count)")
        } else {
          Text("No more speakers.")
        }
        Spacer()
        Button(action: self.nextButtonTapped) {
          Image(systemName: "forward.fill")
        }
      }
    }
    .padding([.bottom, .horizontal])
  }
}

//struct MyContainerView: View {
//  @State var …
//  @Binding var …
//  @ObservedObject var …
//  var body: some View {
//    MyCoreView(…, …, …)
//  }
//}
//struct MyCoreView: View {
//  let …
//  let …
//  let …
//  var body: some View {
//    …
//  }
//}

#Preview {
  MainActor.assumeIsolated {
    NavigationStack {
      RecordMeetingView(
        store: Store(initialState: RecordMeetingFeature.State(
          secondsElapsed: 9,
          standup: .mock)
        ) {
//          RecordMeetingFeature()
        }
      )
    }
  }
}

