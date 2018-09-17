
import Stencil

struct _User {
  let _id: Int
}

try Template(templateString: "{{ user.id | uppercase }}").render(["user": _User(_id: 42)])


let template = Template.init(stringLiteral: """
<ul>
  {% for user in users %}
    <li>{{ user.name }}</li>
  {% endfor %}
</ul>
""")

//print(try template.render(["users": [["name": "Blob"], ["name": "Blob Jr."], ["name": "Blob Sr."]]]))

let name = "Blob"
//print(
//  render(
//    header([
//      h1([.text(name)])
//      ])
//  )
//)

func greet(name: String) -> Node {
  return header([
    h1([.text(name.uppercased())])
    ])
}

print(render(greet(name: "Blob")))

struct User {
  let name: String
  let isAdmin: Bool
}

func adminDetail(user: User) -> [Node] {
  guard user.isAdmin else { return [] }
  return [
    header([
      h1([.text("Welcome admin: \(user.name)")])
      ])
  ]
}

func render(_ nodes: [Node]) -> String {
  return nodes.map(render).joined()
}

print(render(adminDetail(user: User(name: "Blob Jr.", isAdmin: false))))

print(render(adminDetail(user: User(name: "Blob Sr.", isAdmin: true))))

func users(_ names: [String]) -> Node {
  return ul(names.map(userItem))
}

func userItem(_ name: String) -> Node {
  return li([.text(name)])
}

print(render(users(["Blob", "Blob Jr."])))

let template1 = """
<ul>
  {% for user in users %}
    {% include "userItem" user %}
  {% endfor %}
</ul>
"""


class MemoryTemplateLoader: Loader {
  func loadTemplate(name: String, environment: Environment) throws -> Template {
    if name == "userItem" {
      return Template(templateString: """
<li>{{ user }}</li>
""", environment: environment)
    }

    throw TemplateDoesNotExist(templateNames: [name], loader: self)
  }
}

let environment = Environment(loader: MemoryTemplateLoader())

//print(try template1.render(["users": ["Blob", "Blob Jr."]]))

print(
try environment
  .renderTemplate(
    string: template1,
    context: ["users": ["Blob", "Blob Jr."]]
)
)

func redacted(_ node: Node) -> Node {
  switch node {
  case let .el("img", attrs, children):
    return .el(
      "img",
      attrs.filter { attrName, _ in attrName != "src" }
        + [("style", "background: black")],
      children
    )
  case let .el(tag, attrs, children):
    return .el(tag, attrs, children.map(redacted))
  case let .text(string):
    return .text(
      string
        .split(separator: " ")
        .map { String.init(repeating: "█", count: $0.count )}
        .joined(separator: " ")
    )
  }
}


import WebKit
import PlaygroundSupport

let doc = header([
  h1(["Point-Free"]),
  p([id("blurb")], [
    "Functional programming in Swift. ",
    a([href("/about")], ["Learn more"]),
    "!"
    ]),
  img([src("https://pbs.twimg.com/profile_images/907799692339269634/wQEf0_2N_400x400.jpg"), width(64), height(64)])
  ])

let webView = WKWebView(frame: .init(x: 0, y: 0, width: 360, height: 480))
webView.loadHTMLString(render(redacted(doc)), baseURL: nil)
PlaygroundPage.current.liveView = webView


print(render(redacted(doc)))
