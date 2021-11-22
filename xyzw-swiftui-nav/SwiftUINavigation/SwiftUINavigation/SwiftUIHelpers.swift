import CasePaths
import SwiftUI

extension Binding {
  func isPresent<Wrapped>() -> Binding<Bool>
  where Value == Wrapped? {
    .init(
      get: { self.wrappedValue != nil },
      set: { isPresented in
        if !isPresented {
          self.wrappedValue = nil
        }
      }
    )
  }
  
  func isPresent<Enum, Case>(_ casePath: CasePath<Enum, Case>) -> Binding<Bool>
  where Value == Enum? {
    Binding<Bool>(
      get: {
        if let wrappedValue = self.wrappedValue, casePath.extract(from: wrappedValue) != nil {
          return true
        } else {
          return false
        }
      },
      set: { isPresented in
        if !isPresented {
          self.wrappedValue = nil
        }
      }
    )
  }
  
  func `case`<Enum, Case>(_ casePath: CasePath<Enum, Case>) -> Binding<Case?>
  where Value == Enum? {
    Binding<Case?>(
      get: {
        guard
          let wrappedValue = self.wrappedValue,
          let `case` = casePath.extract(from: wrappedValue)
        else { return nil }
        return `case`
      },
      set: { `case` in
        if let `case` = `case` {
          self.wrappedValue = casePath.embed(`case`)
        } else {
          self.wrappedValue = nil
        }
      }
    )
  }
}

extension View {
  func alert<A: View, M: View, Enum, Case>(
    title: (Case) -> Text,
    unwrap data: Binding<Enum?>,
    case casePath: CasePath<Enum, Case>,
    @ViewBuilder actions: @escaping (Case) -> A,
    @ViewBuilder message: @escaping (Case) -> M
  ) -> some View {
    self.alert(
      title: title,
      presenting: data.case(casePath),
      actions: actions,
      message: message
    )
  }

  func confirmationDialog<A: View, M: View, Enum, Case>(
    title: (Case) -> Text,
    unwrap data: Binding<Enum?>,
    case casePath: CasePath<Enum, Case>,
    @ViewBuilder actions: @escaping (Case) -> A,
    @ViewBuilder message: @escaping (Case) -> M
  ) -> some View {
    self.confirmationDialog(
      title: title,
      presenting: data.case(casePath),
      actions: actions,
      message: message
    )
  }

  func alert<A: View, M: View, T>(
    title: (T) -> Text,
    presenting data: Binding<T?>,
    @ViewBuilder actions: @escaping (T) -> A,
    @ViewBuilder message: @escaping (T) -> M
  ) -> some View {
    self.alert(
      data.wrappedValue.map(title) ?? Text(""),
      isPresented: data.isPresent(),
      presenting: data.wrappedValue,
      actions: actions,
      message: message
    )
  }
  
  func confirmationDialog<A: View, M: View, T>(
    title: (T) -> Text,
    titleVisibility: Visibility = .automatic,
    presenting data: Binding<T?>,
    @ViewBuilder actions: @escaping (T) -> A,
    @ViewBuilder message: @escaping (T) -> M
  ) -> some View {
    self.confirmationDialog(
      data.wrappedValue.map(title) ?? Text(""),
      isPresented: data.isPresent(),
      titleVisibility: titleVisibility,
      presenting: data.wrappedValue,
      actions: actions,
      message: message
    )
  }
}

struct IfCaseLet<Enum, Case, Content>: View where Content: View {
  let binding: Binding<Enum>
  let casePath: CasePath<Enum, Case>
  let content: (Binding<Case>) -> Content
  
  init(
    _ binding: Binding<Enum>,
    pattern casePath: CasePath<Enum, Case>,
    @ViewBuilder content: @escaping (Binding<Case>) -> Content
  ) {
    self.binding = binding
    self.casePath = casePath
    self.content = content
  }
  
  var body: some View {
    if let `case` = self.casePath.extract(from: self.binding.wrappedValue) {
      self.content(
        Binding(
          get: { `case` },
          set: { binding.wrappedValue = self.casePath.embed($0) }
        )
      )
    }
  }
}

extension Binding {
  init?(unwrap binding: Binding<Value?>) {
    guard let wrappedValue = binding.wrappedValue
    else { return nil }
    
    self.init(
      get: { wrappedValue },
      set: { binding.wrappedValue = $0 }
    )
  }
}

extension View {
  func sheet<Enum, Case, Content>(
    unwrap optionalValue: Binding<Enum?>,
    case casePath: CasePath<Enum, Case>,
    @ViewBuilder content: @escaping (Binding<Case>) -> Content
  ) -> some View where Case: Identifiable, Content: View {
    self.sheet(unwrap: optionalValue.case(casePath), content: content)
  }

  func sheet<Value, Content>(
    unwrap optionalValue: Binding<Value?>,
    @ViewBuilder content: @escaping (Binding<Value>) -> Content
  ) -> some View where Value: Identifiable, Content: View {
    self.sheet(
      item: optionalValue
    ) { _ in
      if let value = Binding(unwrap: optionalValue) {
        content(value)
      }
    }
  }

  func popover<Enum, Case, Content>(
    unwrap optionalValue: Binding<Enum?>,
    case casePath: CasePath<Enum, Case>,
    @ViewBuilder content: @escaping (Binding<Case>) -> Content
  ) -> some View where Case: Identifiable, Content: View {
    self.popover(unwrap: optionalValue.case(casePath), content: content)
  }

  func popover<Value, Content>(
    unwrap optionalValue: Binding<Value?>,
    @ViewBuilder content: @escaping (Binding<Value>) -> Content
  ) -> some View where Value: Identifiable, Content: View {
    self.popover(
      item: optionalValue
    ) { _ in
      if let value = Binding(unwrap: optionalValue) {
        content(value)
      }
    }
  }
}

extension NavigationLink {
  init<Value, WrappedDestination>(
    unwrap optionalValue: Binding<Value?>,
    onNavigate: @escaping (Bool) -> Void,
    @ViewBuilder destination: @escaping (Binding<Value>) -> WrappedDestination,
    @ViewBuilder label: @escaping () -> Label
  )
  where Destination == WrappedDestination?
  {
    self.init(
      isActive: optionalValue.isPresent().didSet(onNavigate),
      destination: {
        if let value = Binding(unwrap: optionalValue) {
          destination(value)
        }
      },
      label: label
    )
  }
}

extension Binding {
  func didSet(_ callback: @escaping (Value) -> Void) -> Self {
    .init(
      get: { self.wrappedValue },
      set: {
        self.wrappedValue = $0
        callback($0)
      }
    )
  }
}

extension NavigationLink {
  init<Enum, Case, WrappedDestination>(
    unwrap optionalValue: Binding<Enum?>,
    case casePath: CasePath<Enum, Case>,
    onNavigate: @escaping (Bool) -> Void,
    @ViewBuilder destination: @escaping (Binding<Case>) -> WrappedDestination,
    @ViewBuilder label: @escaping () -> Label
  )
  where Destination == WrappedDestination?
  {
    self.init(
      unwrap: optionalValue.case(casePath),
      onNavigate: onNavigate,
      destination: destination,
      label: label
    )
  }
}

struct ToSwiftUI: UIViewControllerRepresentable {
  let viewController: () -> UIViewController
  
  func makeUIViewController(context: Context) -> UIViewController {
    self.viewController()
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
  }
}
