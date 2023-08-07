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
    
    @State var navigation = Navigation()
    
    var body: some View {
        ZStack {
            Group {
                switch navigation.tab {
                case .lifts:
                    LiftsView()
                case .log:
                    LogView()
                }
            }
            .opacity(navigation.sheetBackgroundEffect(presentedVal: 0.8, hiddenVal: 1))
            .scaleEffect(navigation.sheetBackgroundEffect(presentedVal: 0.9, hiddenVal: 1))
            .overlay {
                Color
                    .black
                    .opacity(navigation.sheetBackgroundEffect(presentedVal: 0.8, hiddenVal: 0))
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
            .zIndex(1)
            
            
            
            Group {
                if navigation.addLiftPresented {
                    SheetView(isPresented: $navigation.addLiftPresented) {
                        AddLiftView()
                    }
                }
            }
            .zIndex(2)

            

            if !navigation.sheetPresented {
                TabBarView()
                    .zIndex(3)
            }
        }
        .environment(\.navigation, navigation)
        .animation(Constants.sheetPresentationAnimation, value: navigation.addLiftPresented)
        
        .onAppear {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                do {
                    try modelContext.delete(model: Lift.self)
                } catch {
                    fatalError("couldn't remove items...")
                }
            }
        }
    }
    

    
}

#Preview {
    ContentView()
        .populatedPreviewContainer()
        .background {
            Color.background.ignoresSafeArea()
        }
}


extension Color {
    static var background = Color("Background")
    static var sheetBackground = Color("SheetBackground")
    static var buttonSecondary = Color.white.opacity(0.1)
}
