import XCTest
import WebKit
@testable import PointFreeFramework

class PointFreeFrameworkTests: SnapshotTestCase {
  func testWebView() {
    let html = """
<h1>Welcome to Point-Free!</h1>
<p>A Swift video series exploring functional programming and more.</p>
"""

    let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
    webView.loadHTMLString(html, baseURL: nil)
    assertSnapshot(matching: webView, as: .image)

//    record = true
//    let loaded = expectation(description: "loaded")
//    let delegate = NavigationDelegate.init(callback: {
//      webView.takeSnapshot(with: nil) { (image, error) in
//        loaded.fulfill()
//        self.assertSnapshot(matching: image!, as: .image)
//      }
//    })
//    webView.navigationDelegate = delegate
//    wait(for: [loaded], timeout: 5)
  }
}

class NavigationDelegate: NSObject, WKNavigationDelegate {
  var callback: (() -> Void)?

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    self.callback!()
  }
}

extension Snapshotting where A == WKWebView, Snapshot == UIImage {
//  static let image: Snapshotting = Snapshotting<UIImage, UIImage>.image.pullback { webView in
  static let image: Snapshotting = Snapshotting<UIImage, UIImage>.image.asyncPullback { webView in
    return Parallel<UIImage> { callback in
      let delegate = NavigationDelegate()
      delegate.callback = {
        webView.takeSnapshot(with: nil) { (image, error) in
          callback(image!)
          _ = delegate
        }
      }
      webView.navigationDelegate = delegate
    }
  }
//  static let image = Snapshotting.init(
//    diffing: .image,
//    pathExtension: "png") { webView -> Parallel<UIImage> in
//      return Parallel<UIImage> { callback in
//        let delegate = NavigationDelegate()
//        delegate.callback = {
//          webView.takeSnapshot(with: nil) { (image, error) in
//            callback(image!)
//            _ = delegate
//          }
//        }
//        webView.navigationDelegate = delegate
//      }
//  }
}
