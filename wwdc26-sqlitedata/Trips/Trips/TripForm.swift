import MapKit
import SQLiteData
import SwiftUI

struct TripForm: View {
  @State var showLocationSearch = false
  @State var trip: Trip.Draft

  var body: some View {
    Form {
      Section {
        TextField("Blob's grand adventure", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=$name@*/Binding.constant("")/*@END_MENU_TOKEN@*/)
      } header: {
        Text("Trip Title")
      }

      Section {
        switch /*@START_MENU_TOKEN@*//*@PLACEHOLDER=purpose@*/({Trip.Purpose.personal()}())/*@END_MENU_TOKEN@*/ {
        case .personal:
          Picker("Reason", selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=???@*/.constant(Trip.Purpose.Personal.Reason.family)/*@END_MENU_TOKEN@*/) {
            ForEach(Trip.Purpose.Personal.Reason.allCases) { reason in
              Text(reason.rawValue.lowercased())
            }
          }
        case .business:
          LabeledContent {
            Text("Per diem")
          } label: {
            TextField(
              "$42.00",
              value: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=???@*/.constant(0)/*@END_MENU_TOKEN@*/,
              format: .currency(code: Locale.current.currency?.identifier ?? "USD")
            )
          }
        }
      } header: {
        switch /*@START_MENU_TOKEN@*//*@PLACEHOLDER=purpose@*/({Trip.Purpose.personal()}())/*@END_MENU_TOKEN@*/ {
        case .personal:
          Menu("Personal") {
            Label("Personal", systemImage: "checkmark")
            Button("Business") {
              /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Business action@*//*@END_MENU_TOKEN@*/
            }
          }
        case .business:
          Menu("Business") {
            Button("Personal") {
              /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Personal action@*//*@END_MENU_TOKEN@*/
            }
            Label("Business", systemImage: "checkmark")
          }
        }
      }

      Section(header: Text("Trip Destination")) {
        Button {
          showLocationSearch = true
        } label: {
          HStack {
            Text(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=destination@*/""/*@END_MENU_TOKEN@*/.isEmpty ? "Search for a destination…" : /*@START_MENU_TOKEN@*//*@PLACEHOLDER=destination@*/""/*@END_MENU_TOKEN@*/)
              .foregroundStyle(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=destination@*/""/*@END_MENU_TOKEN@*/.isEmpty ? .secondary : .primary)
            Spacer()
            Image(systemName: "magnifyingglass")
              .foregroundStyle(.secondary)
          }
        }
        Map(
          initialPosition: .region(
            MKCoordinateRegion(
              center: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=location@*/Location()/*@END_MENU_TOKEN@*/.coordinate,
              span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
          )
        ) {
          Marker(
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=destination@*/""/*@END_MENU_TOKEN@*/.isEmpty ? "Location" : /*@START_MENU_TOKEN@*//*@PLACEHOLDER=destination@*/""/*@END_MENU_TOKEN@*/, coordinate: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=location@*/Location()/*@END_MENU_TOKEN@*/.coordinate
          )
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .allowsHitTesting(false)
        .listRowInsets(EdgeInsets())

        Button {
          let request = MKMapItemRequest(mapItemIdentifier: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=mapItemIdentifier@*/MKMapItem.Identifier(rawValue: "I7C250D2CDCB364A")!/*@END_MENU_TOKEN@*/)
          Task {
            if let mapItem = try? await request.mapItem {
              await mapItem.openInMaps(from: nil)
            }
          }
        } label: {
          Label("Open in Maps", systemImage: "map")
        }
      }

      Section {
        TripDatesPicker(startDate: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=$startDate@*/Binding.constant(Date())/*@END_MENU_TOKEN@*/, endDate: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=$endDate@*/Binding.constant(Date())/*@END_MENU_TOKEN@*/)
      } header: {
        Text("Trip Dates")
      }
    }
    .sheet(isPresented: $showLocationSearch) {
      NavigationStack {
        LocationSearchSheet(
          destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=$destination@*/Binding.constant("")/*@END_MENU_TOKEN@*/,
          location: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=$location@*/Binding.constant(Location())/*@END_MENU_TOKEN@*/,
          mapItemIdentifier: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=$mapItemIdentifier@*/Binding.constant(MKMapItem.Identifier(rawValue: "I7C250D2CDCB364A")!)/*@END_MENU_TOKEN@*/
        )
      }
      .presentationDetents([.medium, .large])
    }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button(role: .cancel) {}
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button("Save") {
          /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Save action@*//*@END_MENU_TOKEN@*/
        }
      }
    }
  }
}

private struct TripDatesPicker: View {
  @Environment(\.calendar) private var calendar
  @Environment(\.timeZone) private var timeZone
  @Binding var startDate: Date
  @Binding var endDate: Date

  private var dateRange: ClosedRange<Date> {
    let start = Date.now
    let components = DateComponents(
      calendar: calendar,
      timeZone: timeZone,
      year: 1
    )
    let end = calendar.date(byAdding: components, to: start)!
    return start...end
  }

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("Start Date:")
          .font(.caption)
          .foregroundStyle(.secondary)

        DatePicker(
          selection: $startDate,
          in: dateRange,
          displayedComponents: .date
        ) {
          Label("Start Date", systemImage: "calendar")
        }
        .labelsHidden()
      }
      Spacer()
      VStack(alignment: .leading) {
        Text("End Date:")
          .font(.caption)
          .foregroundStyle(.secondary)

        DatePicker(
          selection: $endDate,
          in: dateRange,
          displayedComponents: .date
        ) {
          Label("End Date", systemImage: "calendar")
        }
        .labelsHidden()
      }
    }
  }
}

struct LocationSearchSheet: View {
  @Binding var destination: String
  @Binding var location: Location?
  @Binding var mapItemIdentifier: MKMapItem.Identifier?

  @Environment(\.dismiss) private var dismiss
  @State private var mapItem: MKMapItem?
  @State private var searchText: String = ""
  @State private var completer = LocationSearchCompleter()

  var body: some View {
    List {
      ForEach(completer.results, id: \.self) { completion in
        Button {
          selectCompletion(completion)
        } label: {
          Label {
            VStack(alignment: .leading) {
              Text(completion.title)
              Text(completion.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
            }
          } icon: {
            Image(systemName: "mappin.circle.fill")
              .foregroundStyle(
                .white,
                .linearGradient(colors: [.red, .pink], startPoint: .top, endPoint: .bottom)
              )
              .font(.title2)
          }
        }
      }
    }
    .navigationTitle("Location")
    .searchable(
      text: $searchText,
      placement: .navigationBarDrawer(displayMode: .always),
      prompt: "Search for a destination…"
    )
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Cancel") { dismiss() }
      }
    }
    .onChange(of: searchText) {
      completer.queryFragment = searchText
    }
    .onAppear {
      searchText = destination
    }
  }

  private func selectCompletion(_ completion: MKLocalSearchCompletion) {
    destination = completion.title

    let request = MKLocalSearch.Request(completion: completion)
    let search = MKLocalSearch(request: request)
    Task {
      if let response = try? await search.start(),
        let item = response.mapItems.first,
         let identifier = item.identifier
      {
        location = Location(
          latitude: item.location.coordinate.latitude,
          longitude: item.location.coordinate.longitude
        )
        mapItemIdentifier = identifier
      }
      dismiss()
    }
  }

  @Observable
  class LocationSearchCompleter: NSObject, MKLocalSearchCompleterDelegate {
    var queryFragment: String = "" {
      didSet {
        completer.queryFragment = queryFragment
      }
    }
    var results: [MKLocalSearchCompletion] = []
    private let completer = MKLocalSearchCompleter()

    init(
      resultTypes: MKLocalSearchCompleter.ResultType = [.address, .pointOfInterest],
      addressFilter: MKAddressFilter? = MKAddressFilter(including: .locality),
      region: MKCoordinateRegion? = nil
    ) {
      super.init()
      completer.delegate = self
      completer.resultTypes = resultTypes
      completer.addressFilter = addressFilter
      if let region {
        completer.region = region
      }
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
      results = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
      results = []
    }
  }
}

struct TripFormPreviews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      TripForm(trip: Trip.Draft())
    }
  }
}
