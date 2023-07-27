//
//  Set.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/13/23.
//
//

import Foundation
import SwiftData

 
//@Model
public class Set {
    var repsCompleted: Int16? = 0
    var targetReps: Int16? = 0
    var weight: Float? = 0.0
    var workout: Workout?
    
    
    init(repsCompleted: Int16? = nil, targetReps: Int16? = nil, weight: Float? = nil, workout: Workout? = nil) {
        self.repsCompleted = repsCompleted
        self.targetReps = targetReps
        self.weight = weight
        self.workout = workout
    }

}
