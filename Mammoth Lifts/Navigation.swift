//
//  Navigation.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/11/23.
//

import Foundation
import SwiftUI



@Observable class CurrentNavigation {
    var current: Navigation = .lifts
}

enum Navigation {
    case lifts
    case log
}
