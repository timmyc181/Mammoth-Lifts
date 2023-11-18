import Foundation
import SwiftUI



@Observable class Navigation {
    var tab: Tab = .lifts
    var addLiftPresented: Bool = false
    
    var liftForWorkout: Lift? = nil
    var workoutPresented: Bool {
        get {
            liftForWorkout != nil
        } set {
            if !newValue {
                liftForWorkout = nil
            }
        }
    }
    
    var liftToLog: Lift? = nil
    var logWorkoutPresented: Bool {
        get {
            liftToLog != nil
        } set {
            if !newValue {
                liftToLog = nil
            }
        }
    }
    
    var liftForDetails: Lift? = nil
    var liftDetailsPresented: Bool {
        get {
            liftForDetails != nil
        } set {
            if !newValue {
                liftForDetails = nil
            }
        }
    }
    
    var streakDetailsPresented: Bool = false
    
    
    var sheetPresentationAmount: CGFloat = 1
    
    var sheetPresented: Bool {
        return addLiftPresented || liftDetailsPresented || workoutPresented || streakDetailsPresented
    }
    
    
    var liftToDelete: Lift? = nil
}


enum Tab {
    case lifts
    case log
}


extension Navigation {
    public func sheetBackgroundEffect(presentedVal: CGFloat, hiddenVal: CGFloat) -> CGFloat {
        if sheetPresented {
            var final: CGFloat = 0
            final += sheetPresentationAmount * presentedVal
            final += (1 - sheetPresentationAmount) * hiddenVal
            
            return final
        } else {
            return hiddenVal
        }
    }
}


extension EnvironmentValues {
    var navigation: Navigation {
        get { self[NavigationKey.self] }
        set { self[NavigationKey.self] = newValue }
    }
}


private struct NavigationKey: EnvironmentKey {
    static var defaultValue: Navigation = Navigation()
}

