//
//  Random_JokesApp.swift
//  Random Jokes
//
//  Created by Tom Wu on 2023-04-14.
//

import SwiftUI
import Blackbird
@main
struct Random_JokesApp: App {
    var body: some Scene {
        WindowGroup {
            JokeView()
                .environment(\.blackbirdDatabase, AppDatabase.instance)
        }
    }
}
