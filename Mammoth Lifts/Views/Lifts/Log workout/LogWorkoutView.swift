//

import SwiftUI

struct LogWorkoutView: View {
    var workout: Workout
    
    var body: some View {
        VStack {
            LogWorkoutHeaderView(name: workout.currentLift!.name)
            Spacer()
            LogWorkoutFooterView()
        }
        .safeAreaPadding(.horizontal, Constants.sheetPadding)
    }
}

//#Preview {
//    LogWorkoutView()
//}
