import SwiftUI
import PlaygroundSupport
import ComposableArchitecture

struct CounterView: View {

  var body: some View {
    HStack {
      Button("-") {  }
      Text("1")
      Button("+") {  }
    }
  }
}

PlaygroundPage.current.liveView = NSHostingController(rootView: CounterView())

1

