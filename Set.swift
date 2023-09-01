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
    var repsCompleted: Int
    var targetReps: Int
    var weight: Double
    @Relationship(deleteRule: .cascade, inverse: \Workout.sets) var workout: Workout?
    
    
    init(repsCompleted: Int = 0, targetReps: Int = 0, weight: Double = 0) {
        self.repsCompleted = repsCompleted
        self.targetReps = targetReps
        self.weight = weight
    }

}
