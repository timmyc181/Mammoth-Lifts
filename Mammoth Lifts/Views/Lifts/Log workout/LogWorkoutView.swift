//

import SwiftUI

struct LogWorkoutView: View {
    @Environment(\.navigation) private var navigation
    @Environment(\.modelContext) private var modelContext
    
    @State var logWorkoutState: LogWorkoutState
    
    init(lift: Lift) {
        self.logWorkoutState = LogWorkoutState(lift: lift)
    }
    
    var body: some View {
        VStack(spacing: 50) {
//            LogWorkoutHeaderView(name: logWorkoutState.lift.name)
            LogWorkoutFormView(logWorkoutState: logWorkoutState)
//            Spacer()
            LogWorkoutFooterView(log: log)
        }
//        .overlay {
//            SmallSheetView(isPresented: $logWorkoutState.sheetPresented, title: logWorkoutState.sheetState.rawValue) {
//                switch logWorkoutState.sheetState {
//                case .none: Color.clear
//                case .date: LogWorkoutDatePickerView(date: $logWorkoutState.workoutDetails.date)
//                case .time: LogWorkoutTimePickerView(date: $logWorkoutState.workoutDetails.date)
//                case .duration: LogWorkoutDurationPickerView(minutes: $logWorkoutState.workoutDetails.durationMinutes, seconds: $logWorkoutState.workoutDetails.durationSeconds)
//                }
//            }
//        }
//        .overlay {
//            WeightKeyboardOverlay(weight: $logWorkoutState.workoutDetails.weight, visible: $logWorkoutState.weightFocused, increment: logWorkoutState.lift.increment)
//        }
//        .animation(Constants.sheetPresentationAnimation, value: logWorkoutState.weightFocused)
    }
    
    func log() {
        let workout = Workout.getLoggedWorkout(weight: logWorkoutState.weight, date: logWorkoutState.date, lift: logWorkoutState.lift)
        
        modelContext.insert(workout)
        
        logWorkoutState.lift.workouts.append(workout)

        navigation.logWorkoutPresented = false
    }
}



//#Preview {
//    LogWorkoutView()
//}
