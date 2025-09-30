import SharingGRDB
import SwiftUI

struct TagsView: View {
  @FetchAll(Tag.order(by: \.title)) var tags
  @Binding var selectedTags: [Tag]

  @Environment(\.dismiss) var dismiss

  var body: some View {
    Form {
      let selectedTagIDs = Set(selectedTags.map(\.id))
      ForEach(tags) { tag in
        TagView(
          isSelected: selectedTagIDs.contains(tag.id),
          selectedTags: $selectedTags,
          tag: tag
        )
      }
    }
    .toolbar {
      ToolbarItem {
        Button("Done") { dismiss() }
      }
    }
    .navigationTitle(Text("Tags"))
  }
}

private struct TagView: View {
  let isSelected: Bool
  @Binding var selectedTags: [Tag]
  let tag: Tag

  var body: some View {
    Button {
      if isSelected {
        selectedTags.removeAll(where: { $0.id == tag.id })
      } else {
        selectedTags.append(tag)
      }
    } label: {
      HStack {
        if isSelected {
          Image.init(systemName: "checkmark")
        }
        Text(tag.title)
      }
    }
    .tint(isSelected ? .accentColor : .primary)
  }
}

#Preview {
  @Previewable @State var tags: [Tag] = []
  let _ = try! prepareDependencies {
    $0.defaultDatabase = try appDatabase()
  }

  TagsView(selectedTags: $tags)
}
