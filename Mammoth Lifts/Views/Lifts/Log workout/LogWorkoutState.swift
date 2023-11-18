import Foundation
import Observation
import SwiftUI


@Observable class LogWorkoutState {
    var lift: Lift
    
    var weight: Weight
    var date: Date
    
    init(lift: Lift) {
        self.lift = lift
        
        self.weight = lift.currentWeight
        self.date = Date()
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
