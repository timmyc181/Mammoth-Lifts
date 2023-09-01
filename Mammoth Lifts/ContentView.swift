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
        GeometryReader { geo in
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
                    
                    
                    if let lift = navigation.liftForDetails {
                        SheetView(isPresented: $navigation.liftDetailsPresented, dragIndicator: true) {
                            LiftDetailsView(lift: lift)
                        }
                    }
                    
                    //                SmallSheetView(
                    //                    isPresented: Binding<Bool> {
                    //                        navigation.liftToDelete != nil
                    //                    } set: { value in
                    //                        if !value {
                    //                            navigation.liftToDelete = nil
                    //                        }
                    //                    },
                    //                    title: "Delete lift?"
                    //                ) {
                    //                    DeleteLiftConfirmationView()
                    //                }
                }
                .zIndex(2)
                .sensoryFeedback(.warning, trigger: navigation.liftToDelete == nil) { oldValue, newValue in
                    return !newValue
                }
                
                ZStack(alignment: .bottom) {
                    Color.black.opacity(navigation.liftToLog == nil ? 0 : 0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            navigation.liftToLog = nil
                        }
                        .allowsHitTesting(navigation.liftToLog != nil)
                        .animation(.smooth(duration: 0.3), value: navigation.liftToLog == nil)
                    
                    if let lift = navigation.liftToLog {
                        SmallSheetView(
                            isPresented: $navigation.logWorkoutPresented,
                            closeMethod: .dragIndicator,
                            safeAreaBottom: geo.safeAreaInsets.bottom
                        ) {
                            LogWorkoutView(lift: lift)
                        }
                    }
                    
                }
                .zIndex(3)
                .ignoresSafeArea()
                
                DatePickerContainerView()
                    .zIndex(4)
                //            .sensoryFeedback(.impact(weight: .medium, intensity: 1), trigger: navigation.logLiftPresented) { oldValue, newValue in
                //                return newValue
                //            }
                
                
                
                
                if !navigation.sheetPresented {
                    TabBarView()
                        .zIndex(2)
                }
            }
            .environment(\.navigation, navigation)
            
            .animation(Constants.sheetPresentationAnimation, value: navigation.addLiftPresented)
            .animation(Constants.sheetPresentationAnimation, value: navigation.logWorkoutPresented)
            .animation(Constants.sheetPresentationAnimation, value: navigation.liftDetailsPresented)
            
            //        .onAppear {
            //            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
            //                do {
            //                    try modelContext.delete(model: Lift.self)
            //                } catch {
            //                    fatalError("couldn't remove items...")
            //                }
            //            }
            //        }
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
