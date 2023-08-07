import Foundation
import Observation
import SwiftUI
import SwiftData


@Observable class AddLiftState {
    var state: State
    var lift: Lift? {
        didSet {
            if lift != nil {
                next()
            }
        }
    }
    var movingForwards: Bool = true
    
    init(state: State = .lift, lift: Lift? = nil) {
        self.state = state
        if let lift = lift {
            do {
                let container = try ModelContainer(for: [Lift.self, Set.self, Workout.self], ModelConfiguration(inMemory: true))

                self.lift = lift
            } catch {
                fatalError("couldn't create model container")
            }

        } else {
            self.lift = nil
        }
    }
    
    

    var progress: Double {
        Double(state.rawValue) / 6
    }
    
    enum State: Int {
        case lift = 1
        case weight = 2
        case setsReps = 3
        case rest = 4
        case increment = 5
        
        
        static func -=(_ x: inout State, _ y: Int){
            x = State(rawValue: x.rawValue - y) ?? .lift
        }
        
        static func +=(_ x: inout State, _ y: Int) {
            x = State(rawValue: x.rawValue + y) ?? .lift
        }
    }
    
    func selectLift(lift: Lift.Option) {
        self.lift = Lift.template(for: lift)
        next()
    }
    
    func next() {
        if movingForwards {
            state = State(rawValue: state.rawValue + 1) ?? .rest

        } else {
            movingForwards = true
        }
    }
    
    func previous() {
        if !movingForwards {
            state = State(rawValue: state.rawValue - 1) ?? .rest

        } else {
            movingForwards = false
        }
    }
    
}


extension EnvironmentValues {
    var addLiftState: AddLiftState {
        get { self[AddLiftStateKey.self] }
        set { self[AddLiftStateKey.self] = newValue }
    }
}


private struct AddLiftStateKey: EnvironmentKey {
    static var defaultValue: AddLiftState = AddLiftState()
}
