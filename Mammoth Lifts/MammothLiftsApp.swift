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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color("Background"))
        }
//        .modelContainer(for: Exercise.self)
//        .modelContainer(
//            for: [Exercise.self, Workout.self, Set.self]
//        )
    }
}
