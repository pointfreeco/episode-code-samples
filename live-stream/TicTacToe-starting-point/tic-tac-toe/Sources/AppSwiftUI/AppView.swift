import AppCore
import ComposableArchitecture
import LoginSwiftUI
import NewGameSwiftUI
import SwiftUI

public struct AppView: View {
  let store: StoreOf<TicTacToe>

  public init(store: StoreOf<TicTacToe>) {
    self.store = store
  }

  public var body: some View {
    switch store.state {
    case .login:
      if let loginStore = store.scope(state: \.login, action: \.login) {
        NavigationStack {
          LoginView(store: loginStore)
        }
      }
    case .newGame:
      if let newGameStore = store.scope(state: \.newGame, action: \.newGame) {
        NavigationStack {
          NewGameView(store: newGameStore)
        }
      }
    }
  }
}
