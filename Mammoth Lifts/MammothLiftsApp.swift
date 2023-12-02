//
//  Mammoth_LiftsApp.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/7/23.
//

import SwiftUI
import SwiftData

@main
struct MammothLiftsApp: App {
    init() {
        UserSettings.prepare()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color("Background"))
                .preferredColorScheme(.dark)
        }
        .modelContainer(
            for: [Lift.self, Workout.self, Set.self],
            isAutosaveEnabled: true
        )
    }
}
