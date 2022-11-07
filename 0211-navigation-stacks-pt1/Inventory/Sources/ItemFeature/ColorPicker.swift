import Models
import SwiftUI

public struct ColorPickerView: View {
  @Binding public var color: Item.Color?
  @Environment(\.dismiss) var dismiss

  public init(color: Binding<Item.Color?>) {
    self._color = color
  }

  public var body: some View {
    Form {
      Button {
        self.color = nil
        self.dismiss()
      } label: {
        HStack {
          Text("None")
          Spacer()
          if self.color == nil {
            Image(systemName: "checkmark")
          }
        }
      }

      ForEach(Item.Color.defaults, id: \.name) { color in
        Button {
          self.color = color
          self.dismiss()
        } label: {
          HStack {
            Text(color.name)
            Spacer()
            if self.color == color {
              Image(systemName: "checkmark")
            }
          }
        }
      }
    }
    .navigationTitle(Text("Color"))
  }
}
