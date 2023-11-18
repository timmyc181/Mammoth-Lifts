import Foundation
import SwiftUI
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
}


extension Workout {
    
    static func getLoggedWorkout(weight: Weight, date: Date, lift: Lift) -> Workout {
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

struct Streak {
    var count: Int = 0
    var nextWorkoutDate: Date
    var lastWorkout: Workout
    
    init?(workouts: [Workout], streakDays: Int) {
        var date = Date().subtracting(days: streakDays).startOfDay

        let workouts = workouts.sorted { workout1, workout2 in
            workout1.date > workout2.date
        }
        
//        print("calculating streak")
        if workouts.count > 0 {
            self.nextWorkoutDate = workouts[0].date.startOfDay.adding(days: streakDays)
            self.lastWorkout = workouts[0]
            
            for workout in workouts {
                if workout.date > date {
                    date = workout.date.startOfDay.subtracting(days: streakDays)
                    count += 1
                } else {
                    break
                }
            }
        } else {
            return nil
        }
        if count == 0 {
            return nil
        }
    }
}

private struct StreakEnvironmentKey: EnvironmentKey {
    static let defaultValue: Streak? = nil
}

extension EnvironmentValues {
    var streak: Streak? {
        get { self[StreakEnvironmentKey.self] }
        set { self[StreakEnvironmentKey.self] = newValue}
    }
}



extension Date {
    func subtracting(days daysAgo: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -daysAgo, to: self)!
    }

    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    var startOfDay: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}
