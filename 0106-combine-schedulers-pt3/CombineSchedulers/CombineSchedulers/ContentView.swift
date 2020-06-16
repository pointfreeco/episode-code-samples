import Combine
import SwiftUI

class RegisterViewModel: ObservableObject {
  struct Alert: Identifiable {
    var title: String
    var id: String { self.title }
  }
  
  @Published var email = ""
  @Published var errorAlert: Alert?
  @Published var isRegistered = false
  @Published var isRegisterRequestInFlight = false
  @Published var password = ""
  @Published var passwordValidationMessage = ""

  let register: (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>

  let scheduler: AnySchedulerOf<DispatchQueue>
//  let scheduler: AnyScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>
//  let scheduler: any Scheduler where .SchedulerTimeType == DispatchQueue.SchedulerTimeType, .SchedulerOptions == DispatchQueue.SchedulerOptions

  var cancellables: Set<AnyCancellable> = []

  init(
    register: @escaping (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>,
    validatePassword: @escaping (String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>,
    scheduler: AnySchedulerOf<DispatchQueue>
  ) {
    self.register = register
    self.scheduler = scheduler

    self.$password
      .debounce(for: .milliseconds(300), scheduler: scheduler)
//      .debounce(for: .milliseconds(300), scheduler: ImmediateScheduler.shared)
      .flatMap { password in
        password.isEmpty
          ? Just("").eraseToAnyPublisher()
          : validatePassword(password)
            .receive(on: scheduler)
//            .receive(on: ImmediateScheduler.shared)
            .map { data, _ in
              String(decoding: data, as: UTF8.self)
          }
          .replaceError(with: "Could not validate password.")
          .eraseToAnyPublisher()
    }
    .sink { [weak self] in self?.passwordValidationMessage = $0 }
    .store(in: &self.cancellables)
  }

  func registerButtonTapped() {
//    scheduler
    self.isRegisterRequestInFlight = true
    self.register(self.email, self.password)
      .receive(on: scheduler)
//      .receive(on: ImmediateScheduler.shared)
      .map { data, _ in
        Bool(String(decoding: data, as: UTF8.self)) ?? false
    }
    .replaceError(with: false)
    .sink {
      self.isRegistered = $0
      self.isRegisterRequestInFlight = false
      if !$0 {
        self.errorAlert = Alert(title: "Failed to register. Please try again.")
      }
    }
    .store(in: &self.cancellables)
  }
}

func registerRequest(
  email: String,
  password: String
) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
  var components = URLComponents(string: "https://www.pointfree.co/register")!
  components.queryItems = [
    URLQueryItem(name: "email", value: email),
    URLQueryItem(name: "password", value: password)
  ]

  return URLSession.shared
    .dataTaskPublisher(for: components.url!)
    .eraseToAnyPublisher()
}


struct ContentView: View {
  @ObservedObject var viewModel: RegisterViewModel

  var body: some View {
    NavigationView {
      if self.viewModel.isRegistered {
        Text("Welcome!")
      } else {
        Form {
          Section(header: Text("Email")) {
            TextField(
              "blob@pointfree.co",
              text: self.$viewModel.email
            )
          }

          Section(header: Text("Password")) {
            TextField(
              "Password",
              text: self.$viewModel.password
            )
            if !self.viewModel.passwordValidationMessage.isEmpty {
              Text(self.viewModel.passwordValidationMessage)
            }
          }

          if self.viewModel.isRegisterRequestInFlight {
            Text("Registering...")
          } else {
            Button("Register") { self.viewModel.registerButtonTapped() }
          }
        }
        .navigationBarTitle("Register")
        .alert(item: self.$viewModel.errorAlert) { errorAlert in
          Alert(title: Text(errorAlert.title))
        }
      }
    }
  }
}

func mockValidate(password: String) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
  let message = password.count < 5 ? "Password is too short 👎"
    : password.count > 20 ? "Password is too long 👎"
    : "Password is good 👍"
  return Just((Data(message.utf8), URLResponse()))
    .setFailureType(to: URLError.self)
    .eraseToAnyPublisher()
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      viewModel: RegisterViewModel(
        register: { _, _ in
          Just((Data("false".utf8), URLResponse()))
            .setFailureType(to: URLError.self)
            .delay(for: 1, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
      },
        validatePassword: {
          mockValidate(password: $0)
            .delay(for: 0.5, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
      },
//        scheduler: AnyScheduler(DispatchQueue.main)
        scheduler: DispatchQueue.main.eraseToAnyScheduler()
      )
    )
  }
}

extension Scheduler {
  func eraseToAnyScheduler() -> AnySchedulerOf<Self> {
    AnyScheduler(self)
  }
}
