/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
View to search and pick a location with autocompletion from MapKit.
*/

import MapKit
import SwiftUI

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
    resultTypes: MKLocalSearchCompleter.ResultType = [
      .address, .pointOfInterest,
    ],
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

  func completer(
    _ completer: MKLocalSearchCompleter,
    didFailWithError error: Error
  ) {
    results = []
  }
}

struct LocationSearchView: View {
  @Binding var destination: String
  @Binding var mapItem: MKMapItem?

  var placeholder: String = "Search for a destination…"
  var resultTypes: MKLocalSearchCompleter.ResultType = [
    .pointOfInterest, .address,
  ]
  var addressFilter: MKAddressFilter? = MKAddressFilter(including: .locality)
  var region: MKCoordinateRegion?

  @State private var completer: LocationSearchCompleter?
  @State private var searchText: String = ""

  var body: some View {
    TextField(placeholder, text: $searchText)
      .autocorrectionDisabled()
      .onChange(of: searchText) {
        completer?.queryFragment = searchText
      }
      #if os(macOS)
        .textInputSuggestions {
          ForEach(completer?.results ?? [], id: \.self) { completion in
            Button {
              selectCompletion(completion)
            } label: {
              CompletionLabel(completion: completion)
            }
          }
        }
      #endif
      .onAppear {
        searchText = destination
        completer = LocationSearchCompleter(
          resultTypes: resultTypes,
          addressFilter: addressFilter,
          region: region
        )
      }
    #if os(iOS)
      ForEach(completer?.results ?? [], id: \.self) { completion in
        Button {
          selectCompletion(completion)
        } label: {
          CompletionLabel(completion: completion)
        }
      }
    #endif
  }

  private func selectCompletion(_ completion: MKLocalSearchCompletion) {
    searchText = completion.title
    destination = completion.title
    completer?.results = []

    let request = MKLocalSearch.Request(completion: completion)
    let search = MKLocalSearch(request: request)
    Task {
      if let response = try? await search.start(),
        let item = response.mapItems.first
      {
        self.mapItem = item
      }
    }
  }
}
struct LocationSearchSheet: View {
  @Binding var destination: String
  @Binding var mapItem: MKMapItem?
  @Environment(\.dismiss) private var dismiss

  @State private var searchText: String = ""
  @State private var completer = LocationSearchCompleter()

  var body: some View {
    List {
      ForEach(completer.results, id: \.self) { completion in
        Button {
          selectCompletion(completion)
        } label: {
          CompletionLabel(completion: completion)
        }
      }
    }
    .navigationTitle("Location")
    #if os(iOS)
      .searchable(
        text: $searchText,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Search for a destination…"
      )
      .navigationBarTitleDisplayMode(.inline)
    #endif
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
        let item = response.mapItems.first
      {
        self.mapItem = item
      }
      dismiss()
    }
  }
}

private struct CompletionLabel: View {
  let completion: MKLocalSearchCompletion
  var body: some View {
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
          .linearGradient(
            colors: [.red, .pink],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .font(.title2)
    }
  }
}
