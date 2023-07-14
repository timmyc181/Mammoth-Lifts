//
//  ContentView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/7/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var navigation = CurrentNavigation()
    
    var body: some View {
        ZStack {
            switch navigation.current {
            case .lifts:
                LiftsView()
            case .log:
                LogView()
            }
            TabBarView()
        }
        .environment(navigation)
        .onAppear {
            do {
                try modelContext.delete(model: Exercise.self)
            } catch {
                
            }
        }
    }
    

    
}


extension Color {
    static var background = Color("Background")
}
