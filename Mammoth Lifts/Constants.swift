//
//  Constants.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/13/23.
//

import Foundation
import SwiftUI

class Constants {
    static let sidePadding: CGFloat = 25
    static let sheetPadding: CGFloat = 30
    static let tabBarSafeArea: CGFloat = 80 // Height of tab bar gradient to pad content
    
//    static let sheetPresentationAnimation: Animation = .snappy(duration: 0.35)
    static let sheetPresentationAnimation: Animation = .smooth(duration: 0.3)
    static let sheetPresentationStiffAnimation: Animation = .bouncy(duration: 0.35, extraBounce: -0.03)
    static let datePickerAnimation: Animation = .snappy(duration: 0.3)
    
    static let setsRange: ClosedRange = 1...10
    static let repsRange: ClosedRange = 1...10
    
    static let restTimeMinutesRange: ClosedRange = 0...10
    static let secondsRange: ClosedRange = 0...59
    
    static let weightRange: Range = 0..<1000

}
