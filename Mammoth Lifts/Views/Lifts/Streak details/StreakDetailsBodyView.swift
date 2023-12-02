//

import SwiftUI

struct StreakDetailsBodyView: View {
    @Environment(\.streak) private var streak
    
    @AppStorage(UserSettings.streakDaysKey) var days: Int = 3
    
    @State private var tabIndex: Int = 0
    
    @State private var height: CGFloat? = nil
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 5) {
    //            Text("Workout frequency")
    //                .customFont(size: 20)
    //                .opacity(0.3)
    //            if let streak {
    //                Text("Next workout")
    //
    //                    .customFont(size: 16, color: .white.opacity(0.3))
    //
    //                ListView {
    //                    ListItemView(divider: false) {
    //                        StreakDetailsNextWorkoutView(date: streak.nextWorkoutDate)
    //                    }
    //                    StreakDetailsLastWorkoutView(workout: streak.lastWorkout)
    //                }
    //
    //                    .padding(.bottom, 40)
    //            } else {
    //                Text("Nothing")
    //                    .customFont()
    //            }
                if let streak {

    //                ListView {
    //
    //                    ListItemView(divider: false) {
    //                        StreakDetailsNextWorkoutView(date: streak.nextWorkoutDate)
    //                    }
    ////                        .padding(.top, 20)
    //                }
    //                VStack(alignment: .leading, spacing: 0) {
    //                    Text("Next workout")
    //                        .customFont(size: 16)
    //                        .opacity(0.3)
    //                    Text("Monday")
    //                        .customFont(size: 24)
    //                }
    //                .padding(.bottom)
                    
    //                StreakDetailsCalendarView()
    //                    .padding(.bottom, 15)
    //
    //                ListView {
    //                    ListItemView(divider: false) {
    //                        StreakDetailsLastWorkoutView(workout: streak.lastWorkout)
    //                    }
    //
    //                }
    //                    .padding(.bottom, 40)
                    ListView {
                        ListItemView {
                                StreakDetailsNextWorkoutView(date: streak.nextWorkoutDate)
                        }

                        StreakCalendarView()
                            .padding(.horizontal)

                        
                        .padding(.vertical, 5)
                        .padding(.top, 5)
                            

                    }
                    .padding(.bottom, 40)
//                    .highPriorityGesture(
//                        DragGesture(minimumDistance: 0)
//                            .onEnded({ val in
//                                print("ended")
//                                
//                            })
//                    )
//                    .background {
//                        Button {
//                            
//                        } label: {
//                            Rectangle()
//                        }
//                    }



                }



                
                
               
                    
                ListView {
                    ListItemView(divider: false) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Lift every ")
                                Spacer(minLength: 0)
                                NumberStepper(value: $days, bounds: 1...20)
                                Text("days")
    //                                .opacity(0.3)
                            }
                            
                        }
                    }
                    
                }
                .padding(.bottom, 5)
                Text("Complete a workout within \(days) days of your last workout. If you take more than \(days) days off, you will lose your streak.")
                    .customFont(size: 14)
                    .opacity(0.3)
            }
        }
        
        
    }
}

struct ViewRectKey: PreferenceKey {
    typealias Value = [ViewRect]

    static var defaultValue: Value = []
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
    

    
}

struct ViewRect: Equatable {
    let id: Int
    let rect: Anchor<CGRect>
}

#Preview {
    DumbPreviewThing {
        StreakDetailsView()

    }
    .populatedPreviewContainer()
//        .safeAreaPadding(.horizontal, Constants.sheetPadding)
}
