import ComposableArchitecture
import SwiftUI

struct ArticlesState: Equatable {
  var articles: [Article] = []
  var isLoading = false
  var readingArticle: Article?
}

enum ArticlesAction {
  case article(index: Int, action: ArticleAction)
  case articlesResponse([Article]?)
  case articleTapped(Article)
  case dismissArticle
  case onAppear
}

enum ArticleAction {
  case favoriteTapped
  case hideTapped
  case readLaterTapped
}

let articlesReducer = Reducer<ArticlesState, ArticlesAction, Void> { state, action, environment in
  switch action {
  case let .article(index: index, action: .favoriteTapped):
    state.articles[index].isFavorite.toggle()
    return .none

  case let .article(index: index, action: .hideTapped):
    state.articles[index].isHidden.toggle()
    return .none

  case let .article(index: index, action: .readLaterTapped):
    state.articles[index].willReadLater.toggle()
    return .none

  case let .articlesResponse(articles):
    state.isLoading = false
    state.articles = articles ?? []
    return .none

  case let .articleTapped(article):
    state.readingArticle = article
    return .none

  case .dismissArticle:
    state.readingArticle = nil
    return .none

  case .onAppear:
    state.isLoading = true
    return Effect(value: .articlesResponse(liveArticles))
      .delay(for: 4, scheduler: DispatchQueue.main)
      .eraseToEffect()
  }
}

struct ComposableArticlesView: View {
  let store: Store<ArticlesState, ArticlesAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        List {
          if viewStore.isLoading {
            ActivityIndicator()
              .padding()
              .frame(maxWidth: .infinity)
          }

          ArticlesListView(store: self.store)
        }
        .sheet(
          item: viewStore.binding(get: \.readingArticle, send: .dismissArticle)
        ) { article in
          NavigationView {
            ArticleDetailView(article: article)
              .navigationTitle(article.title)
          }
        }
        .navigationTitle("Articles")
      }
      .onAppear { viewStore.send(.onAppear) }
    }
  }
}

struct ArticlesListView: View {
  let store: Store<ArticlesState, ArticlesAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      ForEachStore(
        self.store.scope(state: \.articles, action: ArticlesAction.article)
      ) { articleStore in
        WithViewStore(articleStore) { articleViewStore in
          Button(action: { viewStore.send(.articleTapped(articleViewStore.state)) }) {
            ArticleRowView(store: articleStore)
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
    }
  }
}

private struct ArticleRowView: View {
  let store: Store<Article, ArticleAction>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack(alignment: .top) {
        Image("")
          .frame(width: 80, height: 80)
          .background(Color(white: 0.9))
          .padding([.trailing])

        VStack(alignment: .leading) {
          Text(viewStore.title)
            .font(.title)

          Text(articleDateFormatter.string(from: viewStore.date))
            .bold()

          Text(viewStore.blurb)
            .padding(.top, 6)

          HStack {
            Spacer()

            Button(action: { viewStore.send(.favoriteTapped) }) {
              Image(systemName: "star.fill")
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(viewStore.isFavorite ? .red : .blue)
            .padding()

            Button(action: { viewStore.send(.readLaterTapped) }) {
              Image(systemName: "book.fill")
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(viewStore.willReadLater ? .yellow : .blue)
            .padding()

            Button(action: { viewStore.send(.hideTapped) }) {
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
}

private struct ArticleDetailView: View {
  let article: Article

  var body: some View {
    Text(self.article.blurb)
  }
}

struct Composable_Previews: PreviewProvider {
  static var previews: some View {
    ComposableArticlesView(
      store: Store(
        initialState: ArticlesState(),
        reducer: articlesReducer,
        environment: ()
      )
    )
  }
}
