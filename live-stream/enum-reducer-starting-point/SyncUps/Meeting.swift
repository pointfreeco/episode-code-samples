import ComposableArchitecture
import SwiftUI

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
        ForEach(syncUp.attendees) { attendee in
          Text(attendee.name)
        }
        Text("Transcript")
          .font(.headline)
          .padding(.top)
        Text(meeting.transcript)
      }
    }
    .navigationTitle(Text(meeting.date, style: .date))
    .padding()
  }
}
