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
  }
}
