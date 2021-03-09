import Combine
import CombineSchedulers
import SwiftUI

struct Movie: Identifiable {
  let id: UUID
  let name: String
  let isFavorite: Bool
}

class MoviesViewModel: ObservableObject {
  @Published var movies: [Movie] = []

  init() {
    self.allMovies()
      .receive(on: DispatchQueue.main.animation())
      .prepend(
        self.cachedFavorites()
          .receive(on: DispatchQueue.main)
      )
      .scan([], +)
      .assign(to: &self.$movies)
  }

  func allMovies() -> AnyPublisher<[Movie], Never> {
    Just(
      (1...20).map { index in
        Movie(
          id: UUID(),
          name: "Movie \(index)",
          isFavorite: false
        )
      }
    )
    .delay(for: 1, scheduler: DispatchQueue(label: "background.queue"))
    .eraseToAnyPublisher()
  }
  
  func cachedFavorites() -> AnyPublisher<[Movie], Never> {
    Just(
      [
        .init(id: .init(), name: "2001: A Space Odyssey", isFavorite: true),
        .init(id: .init(), name: "Parasite", isFavorite: true),
        .init(id: .init(), name: "Moonlight", isFavorite: true),
      ]
    )
//    .receive(on: DispatchQueue(label: "file.queue"))
    .delay(for: 0.1, scheduler: DispatchQueue(label: "file.queue"))
    .eraseToAnyPublisher()
  }
}

struct ContentView: View {
  @ObservedObject var viewModel: MoviesViewModel

  var body: some View {
    List {
      ForEach(self.viewModel.movies) { movie in
        HStack {
          if movie.isFavorite {
            Image(systemName: "heart.fill")
          } else {
            Image(systemName: "heart.fill")
              .hidden()
          }
          Text(movie.name)
        }
      }
    }
//    .animation(.default)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      viewModel: MoviesViewModel()
    )
  }
}

extension Scheduler {
  func animate(
    withDuration duration: TimeInterval,
    delay: TimeInterval = 0,
    options animationOptions: UIView.AnimationOptions = []
  ) -> AnySchedulerOf<Self> {
    .init(
      minimumTolerance: { self.minimumTolerance },
      now: { self.now },
      scheduleImmediately: { options, action in
        self.schedule(options: options) {
          UIView.animate(
            withDuration: duration,
            delay: delay,
            options: animationOptions,
            animations: action
          )
        }
      },
      delayed: { date, tolerance, options, action in
        self.schedule(after: date, tolerance: tolerance, options: options) {
          UIView.animate(
            withDuration: duration,
            delay: delay,
            options: animationOptions,
            animations: action
          )
        }
      },
      interval: { date, interval, tolerance, options, action in
        self.schedule(after: date, interval: interval, tolerance: tolerance, options: options) {
          UIView.animate(
            withDuration: duration,
            delay: delay,
            options: animationOptions,
            animations: action
          )
        }
      }
    )
  }
}
