//
//  Navigation.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/11/23.
//

import Foundation
import SwiftUI



@Observable class Navigation {
    var tab: Tab = .lifts
    var addLiftPresented: Bool = false {
        didSet {
            sheetGestureEnabled = true
        }
    }
    var editLiftPresented: Bool = false
    var workoutPresented: Bool = false
    
    
    var sheetPresentationAmount: CGFloat = 1
    var sheetGestureEnabled: Bool = true
    
    var sheetPresented: Bool {
        return addLiftPresented || editLiftPresented || workoutPresented
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

