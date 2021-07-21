import ComposableArchitecture
import XCTest
@testable import ConciseForms

class ConciseFormsTests: XCTestCase {
//  func testBasics() {
//    let store = TestStore(
//      initialState: SettingsState(),
//      reducer: conciseSettingsReducer,
//      environment: SettingsEnvironment(
//        mainQueue: DispatchQueue.immediateScheduler.eraseToAnyScheduler(),
//        userNotifications: UserNotificationsClient(
//          getNotificationSettings: { fatalError() },
//          registerForRemoteNotifications: { fatalError() },
//          requestAuthorization: { _ in fatalError() }
//        )
//      )
//    )
//    store.assert(
//      .send(.form(.set(\.displayName, "Blob"))) {
//        $0.displayName = "Blob"
//      },
//      .send(.form(.set(\.displayName, "Blob McBlob, Esq."))) {
//        $0.displayName = "Blob McBlob, Esq"
//      },
//      .send(.form(.set(\.protectMyPosts, true))) {
//        $0.protectMyPosts = true
//      },
//      .send(.form(.set(\.digest, .weekly))) {
//        $0.digest = .weekly
//      }
//    )
//  }
//
//  func testNotifications_HappyPath() {
//    var didRegisterForRemoteNotifications = false
//
//    let store = TestStore(
//      initialState: SettingsState(),
//      reducer: conciseSettingsReducer,
//      environment: SettingsEnvironment(
//        mainQueue: DispatchQueue.immediateScheduler.eraseToAnyScheduler(),
//        userNotifications: UserNotificationsClient(
//          getNotificationSettings: {
//            .init(value: .init(authorizationStatus: .notDetermined))
//          },
//          registerForRemoteNotifications: {
//            .fireAndForget {
//              didRegisterForRemoteNotifications = true
//            }
//          },
//          requestAuthorization: { _ in
//            .init(value: true)
//          }
//        )
//      )
//    )
//
//    store.assert(
//      .send(.form(.set(\.sendNotifications, true))),
//      .receive(.notificationSettingsResponse(.init(authorizationStatus: .notDetermined))) {
//        $0.sendNotifications = true
//      },
//      .receive(.authorizationResponse(.success(true)))
//    )
//
//    XCTAssertEqual(didRegisterForRemoteNotifications, true)
//  }

  func testFoo() {
    let tag = enumTag(SFSpeechRecognizerAuthorizationStatus.authorized)

    print("!")
  }
}

extension SFSpeechRecognizerAuthorizationStatus: CustomReflectable {
  public var customMirror: Mirror {
    .init(reflecting: "hi")
  }
}

import Speech
private func enumTag<Case>(_ `case`: Case) -> UInt32? {
  let metadataPtr = unsafeBitCast(type(of: `case`), to: UnsafeRawPointer.self)
  let kind = metadataPtr.load(as: Int.self)
  let isEnumOrOptional = kind == 0x201 || kind == 0x202
  guard isEnumOrOptional else { return nil }
  let vwtPtr = (metadataPtr - MemoryLayout<UnsafeRawPointer>.size).load(as: UnsafeRawPointer.self)
  let vwt = vwtPtr.load(as: EnumValueWitnessTable.self)
  return withUnsafePointer(to: `case`) { vwt.getEnumTag($0, metadataPtr) }
}

private struct EnumValueWitnessTable {
  let f1, f2, f3, f4, f5, f6, f7, f8: UnsafeRawPointer
  let f9, f10: Int
  let f11, f12: UInt32
  let getEnumTag: @convention(c) (UnsafeRawPointer, UnsafeRawPointer) -> UInt32
  let f13, f14: UnsafeRawPointer
}

