//
//  Mammoth_LiftsApp.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/7/23.
//

import SwiftUI

@main
struct Mammoth_LiftsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
