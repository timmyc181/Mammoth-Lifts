@testable import Mammoth_Lifts
import XCTest
import SwiftData

@MainActor final class StreakTests: XCTestCase {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let streakDays = 3
    


    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let container = try ModelContainer(for: Lift.self, Workout.self, Set.self, configurations: config)
        let deadlift = Lift(name: "Deadlift", currentWeight: 200)
        
        container.mainContext.insert(deadlift)
        
        let dates = [
            Date(timeIntervalSince1970: 1698712771), // Oct 30, 2023
            Date(timeIntervalSince1970: 1698885571), // Nov 1, 2023
            Date(timeIntervalSince1970: 1699648771), // Nov 10, 2023
            Date(timeIntervalSince1970: 1699925971), // Nov 13, 2023
            Date(timeIntervalSince1970: 1700098771), // Nov 15, 2023
            Date(timeIntervalSince1970: 1700357971), // Nov 18, 2023
            Date(timeIntervalSince1970: 1700876371), // Nov 24, 2023
            Date(timeIntervalSince1970: 1701308371), // Nov 29, 2023
            Date(timeIntervalSince1970: 1701481171), // Nov 31, 2023
        ]
        
        for date in dates {
            deadlift.workouts.append(.getLoggedWorkout(weight: 210, date: date, lift: deadlift))
        }
        var data = [Date: CalendarDayStatus]()
        self.measure {
            // 0.012s initial
            // 0.003s after
            data = Streak.calendarDataFor(month: dates[3], workouts: deadlift.workouts.sorted(by: {$0.date < $1.date}), streakDays: streakDays)
        }
        func streakDay(for day: Int) -> CalendarDayStatus {
            let dataSorted = data.sorted(by: { $0.key < $1.key })
            
            return dataSorted[day - 1].value
        }
//        print(data)
        XCTAssertEqual(streakDay(for: 1), .workout(tail: .both))
        XCTAssertEqual(streakDay(for: 9), .nothing)
        XCTAssertEqual(streakDay(for: 10), .workout(tail: .right))
        XCTAssertEqual(streakDay(for: 11), .streak(tail: .both))
        XCTAssertEqual(streakDay(for: 12), .streak(tail: .both))
        XCTAssertEqual(streakDay(for: 13), .workout(tail: .both))
        XCTAssertEqual(streakDay(for: 14), .streak(tail: .both))
        XCTAssertEqual(streakDay(for: 15), .workout(tail: .both))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
