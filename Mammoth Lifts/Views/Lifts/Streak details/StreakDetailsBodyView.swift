//

import SwiftUI

struct StreakDetailsBodyView: View {
    @Environment(\.streak) private var streak
    
    @AppStorage(UserSettings.streakDaysKey) var days: Int = 3
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
//            Text("Workout frequency")
//                .customFont(size: 20)
//                .opacity(0.3)
            if let streak {
                Text("Next workout")
                    
                    .customFont(size: 16, color: .white.opacity(0.3))
                
                ListView {
                    ListItemView(divider: false) {
                        StreakDetailsNextWorkoutView(date: streak.nextWorkoutDate)
                    }
                    StreakDetailsLastWorkoutView(workout: streak.lastWorkout)
                }

                    .padding(.bottom, 40)
            } else {
                Text("Nothing")
                    .customFont()
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
                .customFont(size: 16)
                .opacity(0.3)
        }
        
    }
}

#Preview {
    StreakDetailsView()
//        .safeAreaPadding(.horizontal, Constants.sheetPadding)
}
