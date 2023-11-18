@testable import Mammoth_Lifts
import XCTest
import SwiftData

@MainActor final class WorkoutTests: XCTestCase {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIncrementStreakSingleLift() throws {
        let container = try ModelContainer(for: Lift.self, Workout.self, Set.self, configurations: config)
        let deadlift = Lift(name: "Deadlift", currentWeight: 200)
        
        container.mainContext.insert(deadlift)
        
        let date1 = Date(timeIntervalSinceNow: -20000)
        let date2 = Date(timeIntervalSinceNow: -10000)
        let date3 = Date(timeIntervalSinceNow: 0)

        deadlift.workouts.append(.getLoggedWorkout(weight: 210, date: date1, lift: deadlift))
        deadlift.workouts.append(.getLoggedWorkout(weight: 215, date: date2, lift: deadlift))
        
        var streak = Workout.streakCount(workouts: deadlift.workouts)
        
        XCTAssertEqual(streak, 2)
        
        
        deadlift.workouts.append(.getLoggedWorkout(weight: 220, date: date3, lift: deadlift))
        
        streak = Workout.streakCount(workouts: deadlift.workouts)
        
        XCTAssertEqual(streak, 3)
    }
    
    func testIncrementStreakMultipleLifts() throws {
        let container = try ModelContainer(for: Lift.self, Workout.self, Set.self, configurations: config)
        let deadlift = Lift(name: "Deadlift", currentWeight: 200)
        let benchPress = Lift(name: "Bench press", currentWeight: 200)
        let squat = Lift(name: "Squat", currentWeight: 200)
        
        container.mainContext.insert(deadlift)
        container.mainContext.insert(benchPress)
        container.mainContext.insert(squat)
        
        let date1 = Date(timeIntervalSinceNow: -20000)
        let date2 = Date(timeIntervalSinceNow: -10000)
        let date3 = Date(timeIntervalSinceNow: 0)

        deadlift.workouts.append(.getLoggedWorkout(weight: 210, date: date1, lift: deadlift))
        benchPress.workouts.append(.getLoggedWorkout(weight: 210, date: date2, lift: benchPress))
        
        var workouts = deadlift.workouts + benchPress.workouts
        var streak = Workout.streakCount(workouts: workouts)
        
        XCTAssertEqual(streak, 2)
        
        
        squat.workouts.append(.getLoggedWorkout(weight: 210, date: date3, lift: squat))
        workouts += squat.workouts
        streak = Workout.streakCount(workouts: workouts)
        
        XCTAssertEqual(streak, 3)
    }
    
    func testWorkoutOutsideDateRangeExpectsSameStreak() throws {
        let day = Calendar.current.dateComponents([.day], from: Date()).day!
        
        var date1Components = Calendar.current.dateComponents([.month, .day, .year, .timeZone], from: Date())
        date1Components.hour = 8
        date1Components.minute = 34

        let date1TimeSet = Calendar.current.date(from: date1Components)!
        let date1 = Calendar.current.date(byAdding: .day, value: -(Constants.streaksDays*3 + 1), to: date1TimeSet)!


        var date2Components = Calendar.current.dateComponents([.month, .day, .year, .timeZone], from: Date())
        date2Components.hour = 16
        date2Components.minute = 38

        let date2TimeSet = Calendar.current.date(from: date2Components)!
        let date2 = Calendar.current.date(byAdding: .day, value: -(Constants.streaksDays*2 + 1), to: date2TimeSet)!

        
        var date3Components = Calendar.current.dateComponents([.month, .day, .year, .timeZone], from: Date())
        date3Components.hour = 20
        date3Components.minute = 32

        let date3TimeSet = Calendar.current.date(from: date3Components)!
        let date3 = Calendar.current.date(byAdding: .day, value: -(Constants.streaksDays), to: date3TimeSet)!
        
        
        
        let container = try ModelContainer(for: Lift.self, Workout.self, Set.self, configurations: config)
        let deadlift = Lift(name: "Deadlift", currentWeight: 200)
        
        container.mainContext.insert(deadlift)
        
        deadlift.workouts.append(.getLoggedWorkout(weight: 210, date: date1, lift: deadlift))
        deadlift.workouts.append(.getLoggedWorkout(weight: 215, date: date2, lift: deadlift))
        
        var streak = Workout.streakCount(workouts: deadlift.workouts)

        XCTAssertEqual(streak, 0)
        
        deadlift.workouts.append(.getLoggedWorkout(weight: 220, date: date3, lift: deadlift))
        
        streak = Workout.streakCount(workouts: deadlift.workouts)
        
        XCTAssertEqual(streak, 1)

        
        
    }
    
    func testWorkoutInsideDateRangeExpectsIncrementStreak() throws {
        let day = Calendar.current.dateComponents([.day], from: Date()).day!
        
        var date1Components = Calendar.current.dateComponents([.month, .day, .year, .timeZone], from: Date())
        date1Components.hour = 8
        date1Components.minute = 34

        let date1TimeSet = Calendar.current.date(from: date1Components)!
        let date1 = Calendar.current.date(byAdding: .day, value: -(Constants.streaksDays*3), to: date1TimeSet)!


        var date2Components = Calendar.current.dateComponents([.month, .day, .year, .timeZone], from: Date())
        date2Components.hour = 16
        date2Components.minute = 38

        let date2TimeSet = Calendar.current.date(from: date2Components)!
        let date2 = Calendar.current.date(byAdding: .day, value: -(Constants.streaksDays*2), to: date2TimeSet)!

        
        var date3Components = Calendar.current.dateComponents([.month, .day, .year, .timeZone], from: Date())
        date3Components.hour = 20
        date3Components.minute = 32

        let date3TimeSet = Calendar.current.date(from: date3Components)!
        let date3 = Calendar.current.date(byAdding: .day, value: -(Constants.streaksDays), to: date3TimeSet)!
        
        
        
        let container = try ModelContainer(for: Lift.self, Workout.self, Set.self, configurations: config)
        let deadlift = Lift(name: "Deadlift", currentWeight: 200)
        
        container.mainContext.insert(deadlift)
        
        deadlift.workouts.append(.getLoggedWorkout(weight: 210, date: date1, lift: deadlift))
        deadlift.workouts.append(.getLoggedWorkout(weight: 215, date: date2, lift: deadlift))
        
        var streak = Workout.streakCount(workouts: deadlift.workouts)

        XCTAssertEqual(streak, 0)
        
        deadlift.workouts.append(.getLoggedWorkout(weight: 220, date: date3, lift: deadlift))
        
        streak = Workout.streakCount(workouts: deadlift.workouts)
        
        XCTAssertEqual(streak, 3)

        
        
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
