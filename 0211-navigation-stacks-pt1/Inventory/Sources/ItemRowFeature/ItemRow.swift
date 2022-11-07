import CasePaths
import ItemFeature
import Models
import SwiftUI
import SwiftUINavigation
import XCTestDynamicOverlay

public final class ItemRowModel: Hashable, Identifiable, ObservableObject {
  @Published public var item: Item
  @Published public var destination: Destination?
  @Published var isSaving = false

  public enum Destination: Equatable {
    case deleteConfirmationAlert
    case duplicate(ItemModel)
    case edit(ItemModel)
  }

  public var commitDeletion: () -> Void = unimplemented("ItemRowModel.commitDeletion")
  public var commitDuplication: (Item) -> Void = unimplemented("ItemRowModel.commitDuplication")

  public var id: Item.ID { self.item.id }

  public init(
    destination: Destination? = nil,
    item: Item
  ) {
    self.destination = destination
    self.item = item
  }

  public func deleteButtonTapped() {
    self.destination = .deleteConfirmationAlert
  }

  func deleteConfirmationButtonTapped() {
    self.commitDeletion()
    self.destination = nil
  }

  public func duplicateButtonTapped() {
    self.destination = .duplicate(ItemModel(item: self.item.duplicate()))
  }

  func commitDuplicate() {
    guard case let .some(.duplicate(itemModel)) = self.destination
    else { return }
    self.commitDuplication(itemModel.item)
    self.destination = nil
  }

  public func setEditNavigation(isActive: Bool) {
    self.destination = isActive ? .edit(ItemModel(item: self.item)) : nil
  }

  @MainActor
  func commitEdit() async {
    guard case let .some(.edit(itemModel)) = self.destination
    else { return } // TODO: precondition?

    self.isSaving = true
    defer { self.isSaving = false }

    do {
      // NB: Emulate an API request
      try await Task.sleep(nanoseconds: NSEC_PER_SEC)
    } catch {}

    self.item = itemModel.item
    self.destination = nil
  }

  public func cancelButtonTapped() {
    self.destination = nil
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.item.id)
  }

  public static func == (lhs: ItemRowModel, rhs: ItemRowModel) -> Bool {
    lhs === rhs
  }
}

extension Item {
  public func duplicate() -> Self {
    Self(name: self.name, color: self.color, status: self.status)
  }
}

public struct ItemRowView: View {
  @ObservedObject var model: ItemRowModel

  public init(model: ItemRowModel) {
    self.model = model
  }

  public var body: some View {
    NavigationLink(
      unwrapping: self.$model.destination,
      case: /ItemRowModel.Destination.edit
    ) { isActive in
      self.model.setEditNavigation(isActive: isActive)
    } destination: { $itemModel in
      ItemView(model: itemModel)
        .navigationBarTitle("Edit")
        .navigationBarBackButtonHidden(true)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
              self.model.cancelButtonTapped()
            }
          }
          ToolbarItem(placement: .primaryAction) {
            HStack {
              if self.model.isSaving {
                ProgressView()
              }
              Button("Save") {
                Task { await self.model.commitEdit() }
              }
            }
            .disabled(self.model.isSaving)
          }
        }
    } label: {
      HStack {
        VStack(alignment: .leading) {
          Text(self.model.item.name)

          switch self.model.item.status {
          case let .inStock(quantity):
            Text("In stock: \(quantity)")
          case let .outOfStock(isOnBackOrder):
            Text("Out of stock" + (isOnBackOrder ? ": on back order" : ""))
          }
        }

        Spacer()

        if let color = self.model.item.color {
          Rectangle()
            .frame(width: 30, height: 30)
            .foregroundColor(color.swiftUIColor)
            .border(Color.black, width: 1)
        }

        Button(action: { self.model.duplicateButtonTapped() }) {
          Image(systemName: "square.fill.on.square.fill")
        }
        .padding(.leading)

        Button(action: { self.model.deleteButtonTapped() }) {
          Image(systemName: "trash.fill")
        }
        .padding(.leading)
      }
      .buttonStyle(.plain)
      .foregroundColor(self.model.item.status.isInStock ? nil : Color.gray)
    }
    .alert(
      title: { _ in Text(self.model.item.name) },
      unwrapping: self.$model.destination,
      case: /ItemRowModel.Destination.deleteConfirmationAlert,
      actions: { _ in
        Button("Delete", role: .destructive) {
          self.model.deleteConfirmationButtonTapped()
        }
      },
      message: { _ in
        Text("Are you sure you want to delete this item?")
      }
    )
    .popover(
      unwrapping: self.$model.destination,
      case: /ItemRowModel.Destination.duplicate
    ) { $itemModel in
      NavigationView {
        ItemView(model: itemModel)
          .navigationBarTitle("Duplicate")
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                self.model.cancelButtonTapped()
              }
            }
            ToolbarItem(placement: .primaryAction) {
              Button("Add") {
                self.model.commitDuplicate()
              }
            }
          }
      }
      .frame(minWidth: 300, minHeight: 500)
    }
  }
}

struct ItemRowPreviews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        ItemRowView(
          model: ItemRowModel(
            item: Item(name: "Keyboard", status: .inStock(quantity: 1))
          )
        )
      }
    }
  }
}
