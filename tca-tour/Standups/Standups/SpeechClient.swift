@preconcurrency import Speech

struct SpeechClient {
  var requestAuthorization: @Sendable () async -> SFSpeechRecognizerAuthorizationStatus
  var start: @Sendable () -> AsyncThrowingStream<String, Error>
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
    },
    start: {
      AsyncThrowingStream { continuation in
        let audioSession = AVAudioSession.sharedInstance()
        do {
          try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
          try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
          continuation.finish(throwing: error)
          return
        }

        let audioEngine = AVAudioEngine()
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
        let request = SFSpeechAudioBufferRecognitionRequest()
        let recognitionTask = speechRecognizer.recognitionTask(with: request) { result, error in
          switch (result, error) {
          case let (.some(result), _):
            continuation.yield(result.bestTranscription.formattedString)
          case (_, .some):
            continuation.finish(throwing: error)
          case (.none, .none):
            fatalError("It should not be possible to have both a nil result and nil error.")
          }
        }

        continuation.onTermination = { [audioEngine, recognitionTask] _ in
          _ = speechRecognizer
          audioEngine.stop()
          audioEngine.inputNode.removeTap(onBus: 0)
          recognitionTask.finish()
        }

        audioEngine.inputNode.installTap(
          onBus: 0,
          bufferSize: 1024,
          format: audioEngine.inputNode.outputFormat(forBus: 0)
        ) { buffer, when in
          request.append(buffer)
        }

        audioEngine.prepare()
        do {
          try audioEngine.start()
        } catch {
          continuation.finish(throwing: error)
          return
        }
      }
    }
  )

  static let previewValue = SpeechClient(
    requestAuthorization: { .authorized },
    start: {
      AsyncThrowingStream { continuation in
        Task { @MainActor in
          var finalText = """
              Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor \
              incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud \
              exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute \
              irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla \
              pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui \
              officia deserunt mollit anim id est laborum.
              """
          var text = ""
          while true {
            let word = finalText.prefix { $0 != " " }
            try await Task.sleep(for: .milliseconds(word.count * 50 + .random(in: 0...200)))
            finalText.removeFirst(word.count)
            if finalText.first == " " {
              finalText.removeFirst()
            }
            text += word + " "
            continuation.yield(text)
          }
        }
      }
    }
  )
}

extension DependencyValues {
  var speechClient: SpeechClient {
    get { self[SpeechClient.self] }
    set { self[SpeechClient.self] = newValue }
  }
}
