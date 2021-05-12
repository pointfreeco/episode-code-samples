//
//  DerivedBehaviorApp.swift
//  DerivedBehavior
//
//  Created by Point-Free on 5/12/21.
//

import SwiftUI

@main
struct DerivedBehaviorApp: App {
    var body: some Scene {
        WindowGroup {
          VanillaContentView(
            viewModel: .init()
//            counterViewModel: .init(),
//            profileViewModel: .init()
          )
        }
    }
}
