//

import SwiftUI

struct LogWorkoutFooterView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.navigation) private var navigation
    
    var body: some View {
        Button {
            log()
        } label: {
            Text("Log")
        }
        .buttonStyle(FilledButtonStyle(stretch: true, foregroundColor: FilledButtonStyle.accentForegroundColor, backgroundColor: FilledButtonStyle.accentBackgroundColor))
    }
    
    func log() {
        let workout = navigation.workoutToLog
        
        guard let workout = workout else {
            fatalError("Workout was nil")
        }
        
        workout.lift = workout.currentLift
        
        navigation.logWorkoutPresented = false
    }
}

#Preview {
    LogWorkoutFooterView()
}
