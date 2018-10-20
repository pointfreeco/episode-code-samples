import Foundation

func snapshotUrl(file: StaticString, function: String) -> URL {
  return snapshotDirectoryUrl(file: file)
    .appendingPathComponent(String(function.dropLast(2)))
}

func snapshotDirectoryUrl(file: StaticString) -> URL {
  let fileUrl = URL(fileURLWithPath: "\(file)")
  let directoryUrl = fileUrl
    .deletingLastPathComponent()
    .appendingPathComponent("__Snapshots__")
    .appendingPathComponent(fileUrl.deletingPathExtension().lastPathComponent)
  try! FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true)
  return directoryUrl
}
