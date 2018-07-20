import PointFreeFramework
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  let window = UIWindow()

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {

    self.window.rootViewController = EpisodeListViewController()
    self.window.makeKeyAndVisible()

    return true
  }
}
