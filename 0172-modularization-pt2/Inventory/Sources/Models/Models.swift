import Foundation
import SwiftUI

public struct Item: Equatable, Identifiable {
  public let id = UUID()
  public var name: String
  public var color: Color?
  public var status: Status

  public init(
    name: String,
    color: Color? = nil,
    status: Status
  ) {
    self.name = name
    self.color = color
    self.status = status
  }

  public enum Status: Equatable {
    case inStock(quantity: Int)
    case outOfStock(isOnBackOrder: Bool)

    public var isInStock: Bool {
      guard case .inStock = self else { return false }
      return true
    }
  }

  public struct Color: Equatable, Hashable {
    public var name: String
    public var red: CGFloat = 0
    public var green: CGFloat = 0
    public var blue: CGFloat = 0

    public init(
      name: String,
      red: CGFloat = 0,
      green: CGFloat = 0,
      blue: CGFloat = 0
    ) {
      self.name = name
      self.red = red
      self.green = green
      self.blue = blue
    }

    public static var defaults: [Self] = [
      .red,
      .green,
      .blue,
      .black,
      .yellow,
      .white,
    ]

    public static let red = Self(name: "Red", red: 1)
    public static let green = Self(name: "Green", green: 1)
    public static let blue = Self(name: "Blue", blue: 1)
    public static let black = Self(name: "Black")
    public static let yellow = Self(name: "Yellow", red: 1, green: 1)
    public static let white = Self(name: "White", red: 1, green: 1, blue: 1)

    public var swiftUIColor: SwiftUI.Color {
      .init(red: self.red, green: self.green, blue: self.blue)
    }
  }
}
