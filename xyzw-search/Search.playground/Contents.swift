import MapKit

let completer = MKLocalSearchCompleter()

class LocalSearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    print("succeeded")
    dump(completer.results)
  }

  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    print("failed", error)
  }
}

let delegate = LocalSearchCompleterDelegate()
completer.delegate = delegate

completer.queryFragment = "Apple Store"
