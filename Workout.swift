//
//  Workout.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/13/23.
//
//

import Foundation
import SwiftData


@Model
public class Workout {
    var completionTimeMinutes: Int?
    var completionTimeSeconds: Int?
    var date: Date?
//    var increment: Double?
//    var restTimeMinutes: Int?
//    var restTimeSeconds: Int?
    var targetSets: Int?
    @Relationship(deleteRule: .noAction, inverse: \Lift.workouts) var lift: Lift?
    @Relationship(deleteRule: .cascade) var sets: [Set]
    
    @Transient var currentLift: Lift? = nil
    
    init(completionTimeMinutes: Int? = nil, completionTimeSeconds: Int? = nil, date: Date? = nil, targetSets: Int? = nil, lift: Lift? = nil, sets: [Set] = [], currentLift: Lift? = nil) {
        self.completionTimeSeconds = completionTimeSeconds
        self.completionTimeMinutes = completionTimeMinutes
        self.date = date
//        self.increment = increment
//        self.restTimeMinutes = restTimeMinutes
//        self.restTimeSeconds = restTimeSeconds
        self.targetSets = targetSets
        self.lift = lift
        self.sets = sets
        self.currentLift = currentLift
    }
    
    static func templateFrom(lift: Lift) -> Workout {
        let restTimeSeconds = lift.restTimeSeconds + lift.restTimeMinutes * 60
        let completionTimeEstimateSeconds =
            (lift.targetSets - 1) * restTimeSeconds + // Rest time estimate
            lift.targetSets * 120// Actual lift time estimate
        
        let workout = Workout(
            completionTimeMinutes: completionTimeEstimateSeconds / 60,
            completionTimeSeconds: completionTimeEstimateSeconds % 60,
            date: Date(),
            targetSets: lift.targetSets,
            lift: nil,
            sets: [],
            currentLift: lift
        )
        
        let sets = Array(
            repeating: Set(
                repsCompleted: lift.targetReps,
                targetReps: lift.targetReps,
                weight: lift.currentWeight,
                workout: workout
            ),
            count: lift.targetSets
        )
        
        workout.sets.append(contentsOf: sets)
        
        return workout
    }
    
}
