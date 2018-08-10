import Stencil

let template = Template(
  templateString: """
<h1>Hello {{ name }}!</h1>
"""
)
let htmlStr = try! template.render(["name": "Blob"])
print(htmlStr)

import PlaygroundSupport
import WebKit
let webView = WKWebView(frame: .init(x: 0, y: 0, width: 640, height: 480))
webView.loadHTMLString(htmlStr, baseURL: nil)
PlaygroundPage.current.liveView = webView
