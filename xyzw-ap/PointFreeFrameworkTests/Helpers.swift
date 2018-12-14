import UIKit

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

enum Diff {
  static func lines(_ old: String, _ new: String) -> String? {
    if old == new { return nil }
    let hunks = chunk(diff: diff(
      old.split(separator: "\n", omittingEmptySubsequences: false).map(String.init),
      new.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    ))
    return hunks.flatMap { [$0.patchMark] + $0.lines }.joined(separator: "\n")
  }

  static func images(_ old: UIImage, _ new: UIImage, precision: Float = 1) -> UIImage? {
    if compare(old, new, precision: precision) { return nil }
    return diff(old, new)
  }
}

// MARK: - Private

private struct Difference<A> {
  enum Which {
    case first
    case second
    case both
  }

  let elements: [A]
  let which: Which
}

private func diff<A: Hashable>(_ fst: [A], _ snd: [A]) -> [Difference<A>] {
  var idxsOf = [A: [Int]]()
  fst.enumerated().forEach { idxsOf[$1, default: []].append($0) }

  let sub = snd.enumerated().reduce((overlap: [Int: Int](), fst: 0, snd: 0, len: 0)) { sub, sndPair in
    (idxsOf[sndPair.element] ?? [])
      .reduce((overlap: [Int: Int](), fst: sub.fst, snd: sub.snd, len: sub.len)) { innerSub, fstIdx in

        var newOverlap = innerSub.overlap
        newOverlap[fstIdx] = (sub.overlap[fstIdx - 1] ?? 0) + 1

        if let newLen = newOverlap[fstIdx], newLen > sub.len {
          return (newOverlap, fstIdx - newLen + 1, sndPair.offset - newLen + 1, newLen)
        }
        return (newOverlap, innerSub.fst, innerSub.snd, innerSub.len)
    }
  }
  let (_, fstIdx, sndIdx, len) = sub

  if len == 0 {
    let fstDiff = fst.isEmpty ? [] : [Difference(elements: fst, which: .first)]
    let sndDiff = snd.isEmpty ? [] : [Difference(elements: snd, which: .second)]
    return fstDiff + sndDiff
  } else {
    let fstDiff = diff(Array(fst.prefix(upTo: fstIdx)), Array(snd.prefix(upTo: sndIdx)))
    let midDiff = [Difference(elements: Array(fst.suffix(from: fstIdx).prefix(len)), which: .both)]
    let lstDiff = diff(Array(fst.suffix(from: fstIdx + len)), Array(snd.suffix(from: sndIdx + len)))
    return fstDiff + midDiff + lstDiff
  }
}

private let minus = "−"
private let plus = "+"
private let figureSpace = "\u{2007}"

private struct Hunk {
  let fstIdx: Int
  let fstLen: Int
  let sndIdx: Int
  let sndLen: Int
  let lines: [String]

  var patchMark: String {
    let fstMark = "\(minus)\(fstIdx + 1),\(fstLen)"
    let sndMark = "\(plus)\(sndIdx + 1),\(sndLen)"
    return "@@ \(fstMark) \(sndMark) @@"
  }

  static func +(lhs: Hunk, rhs: Hunk) -> Hunk {
    return Hunk(
      fstIdx: lhs.fstIdx + rhs.fstIdx,
      fstLen: lhs.fstLen + rhs.fstLen,
      sndIdx: lhs.sndIdx + rhs.sndIdx,
      sndLen: lhs.sndLen + rhs.sndLen,
      lines: lhs.lines + rhs.lines
    )
  }

  init(fstIdx: Int = 0, fstLen: Int = 0, sndIdx: Int = 0, sndLen: Int = 0, lines: [String] = []) {
    self.fstIdx = fstIdx
    self.fstLen = fstLen
    self.sndIdx = sndIdx
    self.sndLen = sndLen
    self.lines = lines
  }

  public init(idx: Int = 0, len: Int = 0, lines: [String] = []) {
    self.init(fstIdx: idx, fstLen: len, sndIdx: idx, sndLen: len, lines: lines)
  }
}

private func chunk(diff diffs: [Difference<String>], context ctx: Int = 4) -> [Hunk] {
  func prepending(_ prefix: String) -> (String) -> String {
    return { prefix + $0 + ($0.hasSuffix(" ") ? "¬" : "") }
  }
  let changed: (Hunk) -> Bool = { $0.lines.contains(where: { $0.hasPrefix(minus) || $0.hasPrefix(plus) }) }

  let (hunk, hunks) = diffs
    .reduce((current: Hunk(), hunks: [Hunk]())) { cursor, diff in
      let (current, hunks) = cursor
      let len = diff.elements.count

      switch diff.which {
      case .both where len > ctx * 2:
        let hunk = current + Hunk(len: ctx, lines: diff.elements.prefix(ctx).map(prepending(figureSpace)))
        let next = Hunk(
          fstIdx: current.fstIdx + current.fstLen + len - ctx,
          fstLen: ctx,
          sndIdx: current.sndIdx + current.sndLen + len - ctx,
          sndLen: ctx,
          lines: (diff.elements.suffix(ctx) as ArraySlice<String>).map(prepending(figureSpace))
        )
        return (next, changed(hunk) ? hunks + [hunk] : hunks)
      case .both where current.lines.isEmpty:
        let lines = (diff.elements.suffix(ctx) as ArraySlice<String>).map(prepending(figureSpace))
        let count = lines.count
        return (current + Hunk(idx: len - count, len: count, lines: lines), hunks)
      case .both:
        return (current + Hunk(len: len, lines: diff.elements.map(prepending(figureSpace))), hunks)
      case .first:
        return (current + Hunk(fstLen: len, lines: diff.elements.map(prepending(minus))), hunks)
      case .second:
        return (current + Hunk(sndLen: len, lines: diff.elements.map(prepending(plus))), hunks)
      }
  }

  return changed(hunk) ? hunks + [hunk] : hunks
}

private func compare(_ old: UIImage, _ new: UIImage, precision: Float) -> Bool {
  guard let oldCgImage = old.cgImage else { return false }
  guard let newCgImage = new.cgImage else { return false }
  guard oldCgImage.width != 0 else { return false }
  guard newCgImage.width != 0 else { return false }
  guard oldCgImage.width == newCgImage.width else { return false }
  guard oldCgImage.height != 0 else { return false }
  guard newCgImage.height != 0 else { return false }
  guard oldCgImage.height == newCgImage.height else { return false }
  let byteCount = oldCgImage.width * oldCgImage.height * 4
  var oldBytes = [UInt8](repeating: 0, count: byteCount)
  guard let oldContext = context(for: oldCgImage, data: &oldBytes) else { return false }
  guard let newContext = context(for: newCgImage) else { return false }
  guard let oldData = oldContext.data else { return false }
  guard let newData = newContext.data else { return false }
  if memcmp(oldData, newData, byteCount) == 0 { return true }
  let newer = UIImage(data: new.pngData()!)!
  guard let newerCgImage = newer.cgImage else { return false }
  var newerBytes = [UInt8](repeating: 0, count: byteCount)
  guard let newerContext = context(for: newerCgImage, data: &newerBytes) else { return false }
  guard let newerData = newerContext.data else { return false }
  if memcmp(oldData, newerData, byteCount) == 0 { return true }
  if precision >= 1 { return false }
  var differentPixelCount = 0
  let threshold = 1 - precision
  for x in 0..<oldCgImage.width {
    for y in 0..<oldCgImage.height * 4 {
      if oldBytes[x + x * y] != newerBytes[x + x * y] { differentPixelCount += 1 }
      if Float(differentPixelCount) / Float(byteCount) > threshold { return false}
    }
  }
  return true
}

private func context(for cgImage: CGImage, data: UnsafeMutableRawPointer? = nil) -> CGContext? {
  guard
    let space = cgImage.colorSpace,
    let context = CGContext(
      data: data,
      width: cgImage.width,
      height: cgImage.height,
      bitsPerComponent: cgImage.bitsPerComponent,
      bytesPerRow: cgImage.bytesPerRow,
      space: space,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )
    else { return nil }

  context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
  return context
}

private func diff(_ old: UIImage, _ new: UIImage) -> UIImage {
  let oldCiImage = CIImage(cgImage: old.cgImage!)
  let newCiImage = CIImage(cgImage: new.cgImage!)
  let differenceFilter = CIFilter(name: "CIDifferenceBlendMode")!
  differenceFilter.setValue(oldCiImage, forKey: kCIInputImageKey)
  differenceFilter.setValue(newCiImage, forKey: kCIInputBackgroundImageKey)
  let differenceCiImage = differenceFilter.outputImage!
  let invertFilter = CIFilter(name: "CIColorInvert")!
  invertFilter.setValue(differenceCiImage, forKey: kCIInputImageKey)
  let invertCiImage = invertFilter.outputImage!
  let context = CIContext()
  let invertCgImage = context.createCGImage(invertCiImage, from: invertCiImage.extent)!
  return UIImage(cgImage: invertCgImage)
}
