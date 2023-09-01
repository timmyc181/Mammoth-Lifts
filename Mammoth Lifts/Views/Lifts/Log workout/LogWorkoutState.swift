import Foundation
import Observation
import SwiftUI


@Observable class LogWorkoutState {
    var lift: Lift
    
//    var workoutDetails: WorkoutDetails
    
    var weight: Double
    var date: Date
    
//    var weightFocused: Bool = false
    
    
    init(lift: Lift) {
        self.lift = lift
        
        self.weight = lift.currentWeight
        self.date = Date()
//        self.workoutDetails = WorkoutDetails(
//            weight: lift.currentWeight,
//            date: Date()
//        )
    }
    
    struct WorkoutDetails {
        var weight: Double
        var date: Date
    }
    
}

extension EnvironmentValues {
    var logWorkoutState: LogWorkoutState {
        get { self[LogWorkoutStateKey.self] }
        set { self[LogWorkoutStateKey.self] = newValue }
    }
}


private struct LogWorkoutStateKey: EnvironmentKey {
    static var defaultValue: LogWorkoutState = LogWorkoutState(lift: .template(for: .bench))
}
