//
//  Common.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/12/23.
//

import Foundation


extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}


extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func rad(_ root: Double) -> Double {
        pow(self, 1.0/root)
    }
    
    var decimal: Double {
        return self.truncatingRemainder(dividingBy: 1)
    }
    
    var fractionNum: Int {
        switch self {
        case 0.0625..<0.1875:
            return 1
        case 0.1876..<0.29:
            return 1
        case 0.30..<0.415:
            return 1
        case 0.416..<0.58:
            return 1
        case 0.59..<0.705:
            return 2
        case 0.706..<0.85:
            return 3
        default:
            return 1
        }
    }
    
    var fractionDen: Int {
        switch self {
        case 0.0625..<0.1875:
            return 8
        case 0.1876..<0.29:
            return 4
        case 0.30..<0.415:
            return 3
        case 0.416..<0.58:
            return 2
        case 0.59..<0.705:
            return 3
        case 0.706..<0.85:
            return 4
        default:
            return 1
        }
    }
}
