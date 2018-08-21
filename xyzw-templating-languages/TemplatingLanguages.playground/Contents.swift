import Stencil

precedencegroup ForwardCompose {
  associativity: left
}
infix operator >>>: ForwardCompose
func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
  return { g(f($0)) }
}

class MemoryTemplateLoader: Loader {
  func loadTemplate(name: String, environment: Environment) throws -> Template {
    if name == "user.html" {
      return Template(templateString: """
<li>{{ user }}</li>
""", environment: environment)
    }

    throw TemplateDoesNotExist(templateNames: [name], loader: self)
  }
}

let environment = Environment(loader: MemoryTemplateLoader())

let template = """
<ul>
  {% for user in users %}
    {% include "user.html" user %}
  {% endfor %}
</ul>
"""

let rendered = try environment
  .renderTemplate(string: template, context: ["users": ["Blob", "Blob Jr", "Blob Sr"]])

//let rendered = try template.render()
print(rendered) // "Hello Blob!"


