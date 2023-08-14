//
//  Set.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/13/23.
//
//

import Foundation
import SwiftData

 
@Model
public class Set {
    var repsCompleted: Int?
    var targetReps: Int?
    var weight: Double?
    @Relationship(deleteRule: .cascade, inverse: \Workout.sets) var workout: Workout?
    
    
    init(repsCompleted: Int? = nil, targetReps: Int? = nil, weight: Double? = nil, workout: Workout? = nil) {
        self.repsCompleted = repsCompleted
        self.targetReps = targetReps
        self.weight = weight
        self.workout = workout
    }

}
