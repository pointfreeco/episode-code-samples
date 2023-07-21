import Speech

struct SpeechClient {
  var requestAuthorization: @Sendable () async -> SFSpeechRecognizerAuthorizationStatus
}

import Dependencies

extension SpeechClient: DependencyKey {
  static let liveValue = Self(
    requestAuthorization: {
      await withUnsafeContinuation { continuation in
        SFSpeechRecognizer.requestAuthorization { status in
          continuation.resume(with: .success(status))
        }
      }
    }
  )

  static let previewValue = SpeechClient(
    requestAuthorization: { .authorized }
  )
}

extension DependencyValues {
  var speechClient: SpeechClient {
    get { self[SpeechClient.self] }
    set { self[SpeechClient.self] = newValue }
  }
}
