import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var navigation = Navigation()
    
    @Query(sort: \Workout.date, order: .reverse) var workouts: [Workout]
    @AppStorage(UserSettings.streakDaysKey) var days: Int = 3
//    var streak: Streak? {
//        print("updating")
//        return Streak(workouts: workouts, streakDays: days)
//    }
    
    var body: some View {
        let streak = Streak(workouts: workouts, streakDays: days)
        
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
                    
                    if navigation.streakDetailsPresented {
                        SheetView(isPresented: $navigation.streakDetailsPresented, dragIndicator: true) {
                            StreakDetailsView()
                        }
                    }
                    

                }
                .zIndex(2)
                .sensoryFeedback(.warning, trigger: navigation.liftToDelete == nil) { oldValue, newValue in
                    return !newValue
                }
                
                ZStack(alignment: .bottom) {
                    SmallSheetView(item: $navigation.liftToLog, safeAreaBottom: geo.safeAreaInsets.bottom) { liftToLog in
                        LogWorkoutView(lift: liftToLog)
                            .sheetCloseMethod(.dragIndicator)
                    }
                    
                    SmallSheetView(item: $navigation.liftToDelete, safeAreaBottom: geo.safeAreaInsets.bottom) { liftToDelete in
                        DeleteLiftConfirmationView {
                            navigation.liftToDelete = nil
                            navigation.liftDetailsPresented = false
                            modelContext.delete(liftToDelete)
                            do {
                                try modelContext.save()
                            } catch {
                                fatalError("Error deleting lift")
                            }

                        } close: {
                            navigation.liftToDelete = nil
                        }
                        .sheetCloseMethod(.button)
                        .sheetTitle("Delete lift?")
                        

                        
                    }
                    
                }
                .zIndex(3)
                .ignoresSafeArea()
                
                if !navigation.sheetPresented {
                    TabBarView()
                        .zIndex(2)
                }
            }
            .overlayPreferenceValue(DatePickerPreferenceKey.self) { value in
                DatePickerContainerView(value: value)
            }
            .overlayPreferenceValue(TimePickerPreferenceKey.self) { value in
                TimePickerContainerView(value: value)
            }
            .overlayPreferenceValue(EditWeightPreferenceKey.self) { value in
                SmallSheetView(preference: value,
                               safeAreaBottom: geo.safeAreaInsets.bottom,
                               close: { $0.isPresented.wrappedValue = false }
                ) { (weight, increment, isPresented) in
                    EditWeightView(
                        weight: weight,
                        increment: increment
                    )
                }
                .animation(Constants.sheetPresentationAnimation, value: value == nil)

            }
            .overlayPreferenceValue(CompactDurationPickerPreferenceKey.self) { value in
                CompactDurationPickerPopoverContainerView(value: value)
            }
            
            
            .environment(\.navigation, navigation)
            .environment(\.streak, streak)
            
            .onChange(of: streak?.nextWorkoutDate ?? nil) { _, nextWorkoutDate in
                print("change of next workout date")
                // onChange doesn't work with nil for some reason, so this is a hack
                if let nextWorkoutDate {
                    Notifications.setupNextWorkoutNotification(at: nextWorkoutDate)
                } else {
                    Notifications.removeNextWorkoutNotification()
                }
            }
            
            .animation(Constants.sheetPresentationAnimation, value: navigation.addLiftPresented)
            .animation(Constants.sheetPresentationAnimation, value: navigation.logWorkoutPresented)
            .animation(Constants.sheetPresentationAnimation, value: navigation.liftDetailsPresented)
            .animation(Constants.sheetPresentationAnimation, value: navigation.streakDetailsPresented)
            .animation(Constants.sheetPresentationAnimation, value: navigation.liftToDelete == nil)
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
