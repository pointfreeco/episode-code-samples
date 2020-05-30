import Combine
import SwiftUI

func validationMessage<P: Publisher>(
  forPassword password: P
) -> AnyPublisher<String, Never> where P.Output == String, P.Failure == Never {

  password.map {
    $0.count < 5 ? "Password is too short 👎"
      : $0.count > 20 ? "Password is too long 👎"
      : "Password is good 👍"
  }
  .eraseToAnyPublisher()

}


class RegisterViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var isLoginSuccessful = false
  @Published var passwordValidationMessage = ""

  var cancellables: Set<AnyCancellable> = []

  let login: (String, String) -> AnyPublisher<Bool, Never>

  init(
    login: @escaping (String, String) -> AnyPublisher<Bool, Never>
  ) {
    self.login = login

    self.$password
      .map {
        $0.count < 5 ? "Password is too short 👎"
          : $0.count > 20 ? "Password is too long 👎"
          : "Password is good 👍"
      }
    .sink { self.passwordValidationMessage = $0 }
    .store(in: &self.cancellables)
  }

  func loginButtonTapped() {
    self.login(self.email, self.password)
      .receive(on: DispatchQueue.main)
      .sink { self.isLoginSuccessful = $0 }
    .store(in: &self.cancellables)
  }
}



//class PasswordViewModel: ObservableObject {
//  @Published var password: String = ""
//
//  //let passwordValidationMessage: AnyPublisher<String, Never>
//  @Published var passwordValidationMessage = ""
//
//  func validatePassword() {
//    validationMessage(forPassword: Just(self.password))
//      .sink { self.passwordValidationMessage = $0 }
//  }
//}

struct ContentView: View {
//  @State var password: String = ""
  @ObservedObject var viewModel = RegisterViewModel(
    login: { _, _ in Just(true).eraseToAnyPublisher() }
  )

  var body: some View {
    Form {
      if self.viewModel.isLoginSuccessful {
        Text("Logged in! Welcome!")
      } else {
        TextField("Email", text: self.$viewModel.email)
        TextField("Password", text: self.$viewModel.password)

        Text(self.viewModel.passwordValidationMessage)

        Button("Login") { self.viewModel.loginButtonTapped() }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
