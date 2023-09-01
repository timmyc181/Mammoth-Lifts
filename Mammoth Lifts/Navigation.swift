import Foundation
import SwiftUI



@Observable class Navigation {
    var tab: Tab = .lifts
    var addLiftPresented: Bool = false {
        didSet {
            sheetGestureEnabled = true
        }
    }
    
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
    
    
    var datePicker: DatePickerState? = nil
    
    
    
    var sheetPresentationAmount: CGFloat = 1
    var sheetGestureEnabled: Bool = true
    
    var sheetPresented: Bool {
        return addLiftPresented || liftDetailsPresented || workoutPresented
    }
    
    
    
    var liftToDelete: Lift? = nil
}

struct DatePickerState {
    var position: CGPoint
    var date: Binding<Date>
    
    init(frame: CGRect, date: Binding<Date>) {
        self.position = .init(x: frame.midX, y: frame.midY)
        self.date = date
    }
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

