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
        print("calculating streak")


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
    
    static func calendarDataFor(month: Date, workouts: [Workout], streakDays: Int) -> [Date: CalendarDayStatus] {
        var data = [Date: CalendarDayStatus]()
        var daysLeftInStreak = streakDays
        var workoutIndex = 0
        var dayNum = 1
        var previousDay: Date? = nil
        
        if workouts.count > 0 {
            let startOfMonth = month.firstDayOfMonth.startOfDay
            if workouts[0].date < startOfMonth {
                print("starting")
                print("testing month: \(month)")
                while workoutIndex < workouts.count && workouts[workoutIndex].date < startOfMonth {
                    print("tested for \(workoutIndex)")
                    workoutIndex += 1
                }
//                if workoutIndex < workouts.count {
                    let workoutDay = workouts[workoutIndex - 1].date.startOfDay
                    daysLeftInStreak = streakDays - Calendar.current.dateComponents([.day], from: workoutDay, to: startOfMonth).day!
                    print("days left in streak is \(daysLeftInStreak)")
//                }
            }

        }
        
        for day in month.daysInMonth() {
            if daysLeftInStreak > 0 {
                let tail: CalendarDayTail = daysLeftInStreak > 1 ? .both : .left
                data[day] = .streak(tail: tail)
            } else {
               data[day] = .nothing
            }
            if workoutIndex < workouts.count {
                if Calendar.current.isDate(day, inSameDayAs: workouts[workoutIndex].date) {
                    var tail = CalendarDayTail.right
                    if let previousDay {
                        if case .streak(tail: _) = data[previousDay] {
                            data[previousDay] = .streak(tail: .both)
                            tail = .both
                        }
                    }
                    data[day] = .workout(tail: tail)
                    daysLeftInStreak = streakDays
                    workoutIndex += 1
                }
            } else if daysLeftInStreak == 0 {
                data[day] = .nextWorkout
                print("next")
            }
//            if workouts.contains(where: { workout in
//                Calendar.current.isDate(day, equalTo: workout.date, toGranularity: .day)
//            }) {
//                data[day] = .workout
//            } else if workouts.contains(where: { workout in
//                day.startOfDay >= workout.date.startOfDay
//                && day.startOfDay <= workout.date.adding(days: streakDays - 1)
//            }) {
//                data[day] = .streak
//            } else {
//                data[day] = .nothing
//            }
            daysLeftInStreak -= 1
            previousDay = day
            
        }
        return data
    }
//    static func calendarDataFor(month: Date, workouts: [Workout], streakDays: Int) -> [Date: CalendarDayStatus] {
//        var data = [Date: CalendarDayStatus]()
//        for day in month.daysInMonth() {
//            if workouts.contains(where: { workout in
//                Calendar.current.isDate(day, equalTo: workout.date, toGranularity: .day)
//            }) {
//                data[day] = .workout
//            } else if workouts.contains(where: { workout in
//                day.startOfDay >= workout.date.startOfDay
//                && day.startOfDay <= workout.date.adding(days: streakDays - 1)
//            }) {
//                data[day] = .streak
//            } else {
//                data[day] = .nothing
//            }
//            
//        }
//        return data
//    }

}

enum CalendarDayStatus: Equatable {
    case nothing
    case workout(tail: CalendarDayTail)
    case streak(tail: CalendarDayTail)
    case nextWorkout
    

}

enum CalendarDayTail {
  case left
  case right
  case both
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
