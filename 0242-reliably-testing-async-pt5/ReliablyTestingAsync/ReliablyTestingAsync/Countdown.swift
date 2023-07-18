import Clocks
import SwiftUI

struct CountdownDemo: View {
  @State var countdown = 1000
  @State var isConfettiVisible = false
  let clock: any Clock<Duration>

  init(clock: some Clock<Duration> = ContinuousClock()) {
    self.clock = clock
  }

  var body: some View {
    ZStack {
      Text("\(self.countdown)")
        .font(.system(size: 200).bold())
      if self.isConfettiVisible {
        ForEach(1...100, id: \.self) { _ in
          ConfettiView()
            .offset(x: .random(in: -20...20), y: .random(in: -20...20))
        }
      }
    }
    .task {
      while true {
        if self.countdown == 0 {
          self.isConfettiVisible = true
          break
        }
        try? await self.clock.sleep(for: .seconds(1))
        self.countdown -= 1
      }
    }
  }
}

struct ParticlesModifier: ViewModifier {
  @State var duration = Double.random(in: 2...5)
  @State var time = 0.0
  @State var scale = 0.3

  func body(content: Content) -> some View {
    content
      .scaleEffect(self.scale)
      .modifier(ParticlesEffect(time: self.time))
      .opacity(1 - self.time / self.duration)
      .onAppear {
        withAnimation(.easeOut(duration: self.duration)) {
          self.self.time = self.duration
          self.self.scale = 2.0
        }
      }
  }
}

struct ParticlesEffect: GeometryEffect {
  var direction = Double.random(in: -Double.pi...Double.pi)
  var distance = Double.random(in: 20...400)
  var time: Double

  var animatableData: Double {
    get { self.time }
    set { self.time = newValue }
  }
  func effectValue(size: CGSize) -> ProjectionTransform {
    ProjectionTransform(
      CGAffineTransform(
        translationX: self.distance * cos(self.direction) * self.time,
        y: self.distance * sin(self.direction) * self.time
      )
    )
  }
}

struct ConfettiView: View {
  @State var anchor = CGFloat.random(in: 0...1).rounded()
  @State var color = pointFreeColors.randomElement()!
  @State var isAnimating = false
  @State var rotationOffsetX = Double.random(in: 0...360)
  @State var rotationOffsetY = Double.random(in: 0...360)
  @State var speedX = Double.random(in: 0.5...2)
  @State var speedZ = Double.random(in: 0.5...2)

  var body: some View {
    Rectangle()
      .fill(self.color)
      .frame(width: 20, height: 20, alignment: .center)
      .onAppear(perform: { isAnimating = true })
      .rotation3DEffect(
        .degrees(rotationOffsetX + (isAnimating ? 360 : 0)), axis: (x: 1, y: 0, z: 0)
      )
      .animation(
        Animation.linear(duration: self.speedX).repeatForever(autoreverses: false),
        value: isAnimating
      )
      .rotation3DEffect(
        .degrees(rotationOffsetY + (isAnimating ? 360 : 0)), axis: (x: 0, y: 0, z: 1),
        anchor: UnitPoint(x: self.anchor, y: self.anchor)
      )
      .animation(
        Animation.linear(duration: self.speedZ).repeatForever(autoreverses: false),
        value: isAnimating
      )
      .modifier(ParticlesModifier())
  }
}

private let pointFreeColors = [
  Color.init(red: 152/255, green: 239/255, blue: 181/255),
  Color.init(red: 252/255, green: 241/255, blue: 143/255),
  Color.init(red: 113/255, green: 201/255, blue: 250/255),
  Color.init(red: 141/255, green: 81/255, blue: 246/255),
]

struct CountdownDemo_Previews: PreviewProvider {
  static var previews: some View {
    let _ = swift_task_enqueueGlobal_hook = { job, _ in
      MainActor.shared.enqueue(job)
    }

    CountdownDemo(clock: .immediate)
  }
}
