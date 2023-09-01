//
//  Exercise.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/13/23.
//
//

import Foundation
import SwiftData


@Model
//@Observable
public class Lift {
    @Attribute(.unique) var name: String
    var currentWeight: Double
    var increment: Double
    var restTimeMinutes: Int
    var restTimeSeconds: Int
    var targetReps: Int
    var targetSets: Int
    var warmupSets: Int
    @Relationship(deleteRule: .cascade, inverse: \Workout.lift) var workouts: [Workout]
    
    
    init(name: String, currentWeight: Double = 100, increment: Double = 5, restTimeMinutes: Int = 3, restTimeSeconds: Int = 0, targetReps: Int = 5, targetSets: Int = 5, warmupSets: Int = 3, workouts: [Workout] = []) {
        self.name = name
        self.currentWeight = currentWeight
        self.increment = increment
        self.restTimeMinutes = restTimeMinutes
        self.restTimeSeconds = restTimeSeconds
        self.targetReps = targetReps
        self.targetSets = targetSets
        self.warmupSets = warmupSets
        self.workouts = workouts
    }
    
    enum Option: String, CaseIterable {
        case deadlift = "Deadlift"
        case squat = "Squat"
        case bench = "Bench"
        case overheadPress = "Overhead press"
    }
    
    static func template(for lift: Option) -> Lift {
        switch lift {
        case .deadlift:
            return Lift(
                name: "Deadlift",
                currentWeight: 300,
                increment: 5,
                targetReps: 3,
                targetSets: 5
            )
        case .squat:
            return Lift(
                name: "Squat",
                currentWeight: 250,
                increment: 5,
                targetReps: 3,
                targetSets: 5
            )
        case .bench:
            return Lift(
                name: "Bench",
                currentWeight: 200,
                increment: 2.5,
                targetReps: 5,
                targetSets: 5
            )
        case .overheadPress:
            return Lift(
                name: "Overhead press",
                currentWeight: 150,
                increment: 2.5,
                targetReps: 5,
                targetSets: 5
            )
        }
    }
    
}





//extension Exercise {
//    static func addExercise(managedObjectContext: NSManagedObjectContext, currentWeight: Float, increment: Float, name: String, restTimeSeconds: Int, targetReps: Int, targetSets: Int) {
//
//        let newExercise = Exercise(context: managedObjectContext)
//
//        newExercise.currentWeight = currentWeight
//        newExercise.increment = increment
//        newExercise.name = name
//        newExercise.restTimeSeconds = Int16(restTimeSeconds)
//        newExercise.targetReps = Int16(targetReps)
//        newExercise.targetSets = Int16(targetSets)
//
//
//        do {
//            try managedObjectContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//
//    }
//
//    func delete(managedObjectContext: NSManagedObjectContext) {
//        managedObjectContext.delete(self)
//
//        do {
//            try managedObjectContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
//}


extension Lift {
    func estimatedCompletionTime() -> (Int, Int) {
        let restTimeSeconds = restTimeSeconds + restTimeMinutes * 60
        let estimatedCompletionTimeSeconds =
            (targetSets - 1) * restTimeSeconds + // Rest time estimate
            targetSets * 120// Actual lifting time estimate
        
        return (estimatedCompletionTimeSeconds / 60, estimatedCompletionTimeSeconds % 60)
    }
}
