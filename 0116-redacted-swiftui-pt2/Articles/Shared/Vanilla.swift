import SwiftUI

class AppViewModel: ObservableObject {
  @Published var articles: [Article] = []
  @Published var isLoading = false
  @Published var readingArticle: Article?

  init() {
    self.isLoading = true

    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      self.articles = liveArticles
      self.isLoading = false
    }
  }

  func tapped(article: Article) {
    self.readingArticle = article
  }
}

extension RedactionReasons {
  static let loading = RedactionReasons(rawValue: 1)
}

struct VanillaArticlesView: View {
  @ObservedObject private var viewModel = AppViewModel()

  var body: some View {
    NavigationView {
      List {
        if self.viewModel.isLoading {
          ActivityIndicator()
            .frame(maxWidth: .infinity)
            .padding()
        }

        ForEach(
          self.viewModel.isLoading
            ? placeholderArticles
            : self.viewModel.articles.filter { !$0.isHidden }
        ) { article in
          Button(
            action: {
              guard !self.viewModel.isLoading else { return }
              self.viewModel.tapped(article: article)
            }
          ) {
            ArticleRowView(article: article)
          }
        }
        .redacted(reason: self.viewModel.isLoading ? .placeholder : [])
        .disabled(self.viewModel.isLoading)
      }
      .sheet(item: self.$viewModel.readingArticle) { article in
        NavigationView {
          ArticleDetailView(article: article)
            .navigationTitle(article.title)
        }
      }
      .navigationTitle("Articles")
    }
  }
}

class ArticleViewModel: ObservableObject {
  @Published var article: Article

  init(article: Article) {
    self.article = article
  }

  func favorite() {
    // Make API request to favorite article on server
    self.article.isFavorite.toggle()
  }

  func readLater() {
    // Make API request to add article to read later list
    self.article.willReadLater.toggle()
  }

  func hide() {
    // Make API request to hide article so we never see it again
    self.article.isHidden.toggle()
  }
}

private struct ArticleRowView: View {
  @StateObject var viewModel: ArticleViewModel
  @Environment(\.redactionReasons) var redactionReasons

  @State var value = 1

  init(article: Article) {
    self._viewModel = StateObject(wrappedValue: ArticleViewModel(article: article))
  }

  var body: some View {
    HStack(alignment: .top) {
      Image("")
        .frame(width: 80, height: 80)
        .background(Color.init(white: 0.9))
        .padding([.trailing])

      VStack(alignment: .leading) {
        Text(self.viewModel.article.title)
          .font(.title)

        Text(articleDateFormatter.string(from: self.viewModel.article.date))
          .bold()

        Text(self.viewModel.article.blurb)
          .padding(.top, 6)

        HStack {
          Spacer()

          Button(
            action: {
              guard self.redactionReasons.isEmpty else { return }
              self.viewModel.favorite()
            }) {
            Image(systemName: "star.fill")
          }
          .buttonStyle(PlainButtonStyle())
          .foregroundColor(self.viewModel.article.isFavorite ? .red : .blue)
          .padding()

          Button(
            action: {
              guard self.redactionReasons.isEmpty else { return }
              self.viewModel.readLater()
            }) {
            Image(systemName: "book.fill")
          }
          .buttonStyle(PlainButtonStyle())
          .foregroundColor(self.viewModel.article.willReadLater ? .yellow : .blue)
          .padding()

          Button(
            action: {
              guard self.redactionReasons.isEmpty else { return }
              self.viewModel.hide()
            }) {
            Image(systemName: "eye.slash.fill")
          }
          .buttonStyle(PlainButtonStyle())
          .foregroundColor(.blue)
          .padding()
        }
      }
    }
    .padding([.top, .bottom])
    .buttonStyle(PlainButtonStyle())
  }
}

fileprivate struct ArticleDetailView: View {
  let article: Article

  var body: some View {
    Text(article.blurb)
  }
}
struct Vanilla_Previews: PreviewProvider {
  static var previews: some View {
    VanillaArticlesView()
  }
}
