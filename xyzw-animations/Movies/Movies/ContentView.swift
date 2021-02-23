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
    self.cancellable = self.allMovies()
      .receive(on: DispatchQueue.main)
//      .assign(to: &self.$movies)
      .sink { [weak self] movies in
        withAnimation {
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
          isFavorite: index.isMultiple(of: 2)
        )
      }
    )
    .delay(for: 1, scheduler: DispatchQueue(label: "background.queue"))
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
