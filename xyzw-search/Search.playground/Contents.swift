import MapKit

let completer = MKLocalSearchCompleter()

class LocalSearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    print("succeeded")
    dump(completer.results)


    let search = MKLocalSearch(request: .init(completion: completer.results[0]))
    Task {
      let response = try await search.start()
      print(response.mapItems)

      response.mapItems[0].placemark.coordinate
      response.boundingRegion
    }

  }

  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    print("failed", error)
  }
}

let delegate = LocalSearchCompleterDelegate()
completer.delegate = delegate

completer.queryFragment = "Apple Store"

//MKLocalSearch.init(request: .init(coordinateRegion: <#T##MKCoordinateRegion#>))

