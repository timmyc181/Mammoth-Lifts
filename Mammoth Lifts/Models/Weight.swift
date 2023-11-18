import Foundation
import SwiftUI


struct Weight: Equatable, Codable {
    private var value: Int
    
    var a: Int {value}
    
    init(_ weight: Double) {
        value = Int(weight * 100)
    }
    
    init(_ weight: Int) {
        value = weight * 100
    }
    
    private init(internalValue value: Int) {
        self.value = value
    }

    init(_ text: String) {
        let numericText = text.filter("0123456789".contains)
        
        var multiplyBy = 100

        let components = text.components(separatedBy: ".")
        if components.count > 1 {
            switch components[1].count {
            case 1: multiplyBy = 10
            case 2: multiplyBy = 1
            default: break
            }
        }
        
        value = (Int(numericText) ?? 0) * multiplyBy
    }
    
    
    
    var text: String {
        var string = String(value / 100)
        if value % 100 != 0 {
            string += "." + String((value / 10) % 10)
            if value % 10 != 0 {
                string += String(value % 10)
            }
        }
        return string
    }
    
    var whole: Int { value / 100 }
    var wholeDigits: [String] { String(describing: whole).compactMap { String($0) }}
    var decimalOne: Int { value % 100 / 10 }
    var decimalTwo: Int { value % 10 }
}

extension Weight {
    enum DigitLocation {
        case whole, decimalOne, decimalTwo
    }
}


extension Weight {
    static func +=(lhs: inout Weight, rhs: Weight) {
        lhs.value = lhs.value + rhs.value
    }
    
    
    static func +(lhs: Weight, rhs: Weight) -> Weight {
        Weight(internalValue: lhs.value + rhs.value)
    }
    
    
    
    
    static func -=(lhs: inout Weight, rhs: Weight) {
        lhs.value = lhs.value - rhs.value
    }
    
    static func -(lhs: Weight, rhs: Weight) -> Weight {
        Weight(internalValue: lhs.value - rhs.value)
    }
}

extension Weight: Comparable {
    static func < (lhs: Weight, rhs: Weight) -> Bool {
        lhs.value < rhs.value
    }
}

extension Weight: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    typealias FloatLiteralType = Double
    typealias IntegerLiteralType = Int
    
    init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
    
    init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
    
}


extension String {
    init(_ weight: Weight) {
        self.init(weight.text)
    }
}
