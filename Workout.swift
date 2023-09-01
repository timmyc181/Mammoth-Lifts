import Foundation
import SwiftData


@Model
public class Workout {
    var durationMinutes: Int
    var durationSeconds: Int
    var date: Date
    var targetSets: Int
    @Relationship(deleteRule: .noAction) var lift: Lift?
    @Relationship(deleteRule: .cascade) var sets: [Set]
    
    init(durationMinutes: Int, durationSeconds: Int, date: Date, targetSets: Int, sets: [Set] = []) {
        self.durationMinutes = durationMinutes
        self.durationSeconds = durationSeconds
        self.date = date
        self.targetSets = targetSets
        self.sets = sets
    }
    
//    static func templateFrom(lift: Lift) -> Workout {
//        let restTimeSeconds = lift.restTimeSeconds + lift.restTimeMinutes * 60
//        let completionTimeEstimateSeconds =
//            (lift.targetSets - 1) * restTimeSeconds + // Rest time estimate
//            lift.targetSets * 120// Actual lift time estimate
//        
//        let workout = Workout(
//            completionTimeMinutes: completionTimeEstimateSeconds / 60,
//            completionTimeSeconds: completionTimeEstimateSeconds % 60,
//            date: Date(),
//            targetSets: lift.targetSets,
//            lift: nil,
//            sets: [],
//            currentLift: lift
//        )
//        
//        let sets = Array(
//            repeating: Set(
//                repsCompleted: lift.targetReps,
//                targetReps: lift.targetReps,
//                weight: lift.currentWeight,
//                workout: workout
//            ),
//            count: lift.targetSets
//        )
//        
//        workout.sets.append(contentsOf: sets)
//        
//        return workout
//    }
    
    
}


extension Workout {
    
    static func getLoggedWorkout(weight: Double, date: Date, lift: Lift) -> Workout {
        let sets = Array(
            repeating: Set(
                repsCompleted: lift.targetReps,
                targetReps: lift.targetReps,
                weight: weight
            ),
            count: lift.targetSets
        )
        
        return Workout(
            durationMinutes: lift.restTimeMinutes,
            durationSeconds: lift.restTimeSeconds,
            date: date,
            // FIXME: redo log workout to match complexity of regular workout, eg. allow target sets, adding individual sets, adding incomplete sets, etc.
            targetSets: lift.targetSets,
            sets: sets
        )
    }
    
}
