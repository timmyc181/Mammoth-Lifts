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
    var competionTimeSeconds: Int16? = 0
    var date: Date?
    var increment: Float? = 0.0
    var restTimeSeconds: Int16? = 0
    var targetSets: Int16? = 0
    var exercise: Lift?
    @Relationship(inverse: \Set.workout) var sets: [Set]?
    
    
    
    init(competionTimeSeconds: Int16? = nil, date: Date? = nil, increment: Float? = nil, restTimeSeconds: Int16? = nil, targetSets: Int16? = nil, exercise: Lift? = nil, sets: [Set]? = nil) {
        self.competionTimeSeconds = competionTimeSeconds
        self.date = date
        self.increment = increment
        self.restTimeSeconds = restTimeSeconds
        self.targetSets = targetSets
        self.exercise = exercise
        self.sets = sets
    }
    
}
