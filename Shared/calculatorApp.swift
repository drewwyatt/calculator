//
//  calculatorApp.swift
//  Shared
//
//  Created by Drew Wyatt on 1/1/22.
//

import SwiftUI
import ComposableArchitecture

@main
struct calculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(
                initialState: State(),
                reducer: counterReducer,
                environment: Environment()
              ))
        }
    }
}
