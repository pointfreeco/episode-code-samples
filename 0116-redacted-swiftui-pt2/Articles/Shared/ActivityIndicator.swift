import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
  init() {}

  func makeUIView(context: Context) -> UIActivityIndicatorView {
    let view = UIActivityIndicatorView(style: .large)
    view.startAnimating()
    return view
  }

  func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
