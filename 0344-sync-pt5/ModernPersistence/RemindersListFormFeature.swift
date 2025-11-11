import PhotosUI
import SQLiteData
import SwiftUI

struct RemindersListForm: View {
  @Dependency(\.defaultDatabase) var database
  @Environment(\.dismiss) var dismiss
  @State var remindersList: RemindersList.Draft
  @State var coverImageData: Data?
  @State var isPhotoPickerPresented = false
  @State var photoPickerItem: PhotosPickerItem?

  var body: some View {
    Form {
      Section {
        VStack {
          TextField("List Name", text: $remindersList.title)
            .font(.system(.title2, design: .rounded, weight: .bold))
            .foregroundStyle(Color(hex: remindersList.color))
            .multilineTextAlignment(.center)
            .padding()
            .textFieldStyle(.plain)
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(.buttonBorder)
      }
      ColorPicker("Color", selection: $remindersList.color.swiftUIColor)

      ZStack(alignment: .topTrailing) {
        ZStack {
          if let coverImageData, let coverImage = UIImage(data: coverImageData) {
            Image(uiImage: coverImage)
              .resizable()
              .scaledToFill()
              .frame(height: 150)
              .clipped()
              .cornerRadius(10)
          } else {
            Rectangle()
              .fill(Color.secondary.opacity(0.1))
              .frame(height: 150)
              .cornerRadius(10)
          }

          Button("Select Cover Image") {
            isPhotoPickerPresented = true
          }
          .padding()
          .background(.ultraThinMaterial)
          .clipShape(.capsule)
        }

        if coverImageData != nil {
          Button {
            coverImageData = nil
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.red)
              .background(Color.white)
              .clipShape(Circle())
          }
          .padding(8)
        }
      }
      .buttonStyle(.plain)
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem {
        Button("Save") {
          withErrorReporting {
            try database.write { db in
              let remindersListID = try RemindersList.upsert { remindersList }
                .returning(\.id)
                .fetchOne(db)
              guard let remindersListID else { return }
              if let coverImageData {
                try RemindersListAsset.upsert {
                  RemindersListAsset(
                    remindersListID: remindersListID,
                    coverImage: coverImageData
                  )
                }
                .execute(db)
              } else {
                try RemindersListAsset.find(remindersListID).delete().execute(db)
              }
            }
          }
          dismiss()
        }
      }
      ToolbarItem(placement: .cancellationAction) {
        Button("Cancel") {
          dismiss()
        }
      }
    }
    .task {
      guard let remindersListID = remindersList.id
      else { return }
      await withErrorReporting {
        coverImageData = try await database.read { db in
          try RemindersListAsset
            .where { $0.remindersListID.eq(remindersListID) }
            .select(\.coverImage)
            .fetchOne(db)
        }
      }
    }
    .photosPicker(isPresented: $isPhotoPickerPresented, selection: $photoPickerItem)
    .onChange(of: photoPickerItem) {
      Task {
        if let photoPickerItem {
          await withErrorReporting {
            coverImageData = try await photoPickerItem.loadTransferable(type: Data.self)
              .flatMap { resizedAndOptimizedImageData(from: $0) }
            self.photoPickerItem = nil
          }
        }
      }
    }
  }

  private func resizedAndOptimizedImageData(from data: Data, maxWidth: CGFloat = 1000) -> Data? {
    guard let image = UIImage(data: data) else { return nil }

    let originalSize = image.size
    let scaleFactor = min(1, maxWidth / originalSize.width)
    let newSize = CGSize(
      width: originalSize.width * scaleFactor,
      height: originalSize.height * scaleFactor
    )

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
    image.draw(in: CGRect(origin: .zero, size: newSize))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return resizedImage?.jpegData(compressionQuality: 0.8)
  }
}

extension Int {
  var swiftUIColor: Color {
    get {
      Color(hex: self)
    }
    set {
      guard let components = UIColor(newValue).cgColor.components
      else { return }
      let r = Int(components[0] * 0xFF) << 24
      let g = Int(components[1] * 0xFF) << 16
      let b = Int(components[2] * 0xFF) << 8
      let a = Int((components.indices.contains(3) ? components[3] : 1) * 0xFF)
      self = r | g | b | a
    }
  }
}

struct RemindersListFormPreviews: PreviewProvider {
  static var previews: some View {
    let _ = prepareDependencies {
      $0.defaultDatabase = try! appDatabase()
    }
    
    Form {
    }
    .sheet(isPresented: .constant(true)) {
      NavigationStack {
        RemindersListForm(
          remindersList: RemindersList.Draft(
            id: UUID(2),
            color: 0xef7e4a_ff,
            title: "Family"
          )
        )
      }
      .presentationDetents([.medium])
    }
  }
}
