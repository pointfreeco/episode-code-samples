import SwiftUI

struct ContentView: View {
  @State var circleCenter = CGPoint.zero
  @State var circleColor = Color.black
  @State var isCircleScaled = false
  @State var isResetting = false

  var body: some View {
    VStack {
      Circle()
        .fill(self.circleColor)
//        .animation(.linear)
        .overlay(Text("Hi"))
        .frame(width: 50, height: 50)
        .scaleEffect(self.isCircleScaled ? 2 : 1)
//        .animation(nil, value: self.isCircleScaled)
//        .animation(.disabled)
        .offset(x: self.circleCenter.x - 25, y: self.circleCenter.y - 25)
//        .animation(self.isResetting ? nil : .spring(response: 0.3, dampingFraction: 0.1))
        .gesture(
          DragGesture(minimumDistance: 0).onChanged { value in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.1)) {
              self.circleCenter = value.location
            }
          }
        )
        .foregroundColor(self.isCircleScaled ? .red : nil)
//      if self.isCircleScaled {
//        circle.foregroundColor(.red)
//      } else {
//        circle
//      }

      Toggle(
        "Scale",
        isOn: self.$isCircleScaled.animation(.spring(response: 0.3, dampingFraction: 0.1))

//          Binding(
//          get: { self.isCircleScaled },
//          set: { isOn in
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.1)) {
//              self.isCircleScaled = isOn
//            }
//          }
//        )

      )

      Button("Cycle colors") {
        [Color.red, .blue, .green, .purple, .black]
          .enumerated()
          .forEach { offset, color in
            DispatchQueue.main.asyncAfter(deadline:   .now() + .seconds(offset)) {
              withAnimation(.linear) {
                self.circleColor = color
              }

              // withAnimation: (() -> R) -> R
              // Async<A> = ((A) -> Void) -> Void
              //            ((A) -> R) -> R
            }
          }
//        DispatchQueue.main.asyncAfter(deadline:   .now() + 1) {
//          self.circleColor = .blue
//        }
//        DispatchQueue.main.asyncAfter(deadline:   .now() + 2) {
//          self.circleColor = .green
//        }
//        DispatchQueue.main.asyncAfter(deadline:   .now() + 3) {
//          self.circleColor = .purple
//        }
//        DispatchQueue.main.asyncAfter(deadline:   .now() + 4) {
//          self.circleColor = .black
//        }
      }
      
      Button("Reset") {
//        self.isResetting = true
        withAnimation {
          self.circleCenter = .zero
          self.circleColor = .black
        }
        self.isCircleScaled = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
//          self.isResetting = false
//        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
