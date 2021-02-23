import Combine
import SwiftUI

struct Movie: Identifiable {
  let id: UUID
  let name: String
  let isFavorite: Bool
}

class MoviesViewModel: ObservableObject {
  @Published var movies: [Movie] = []
  private var cancellable: Cancellable?

  init() {
    var count = 0
    self.cancellable = self.allMovies()
      .prepend(self.cachedFavorites())
      .scan([], +)
      .receive(on: DispatchQueue.main)
//      .assign(to: &self.$movies)
      .sink { [weak self] movies in
        count += 1
        withAnimation(count == 1 ? nil : .default) {
          self?.movies = movies
        }
      }
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
