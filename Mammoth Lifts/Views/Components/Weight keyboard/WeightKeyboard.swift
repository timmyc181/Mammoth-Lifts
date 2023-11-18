import Foundation
import SwiftUI


//@Observable
//class WeightKeyboard {
//    private var weight: Binding<Weight>
////    private var 
//    var digitLocation: Weight.DigitLocation = .whole
//    var decimalActive: Bool = false
//}

struct WeightKeyboard {
    private let _weight: Binding<Weight>
    private var weightBinding: Binding<Weight> {
        print("made")
        return Binding {
//            if self.weight.decimalOne != 0  {
//                digitLocation = .decimalOne
//                decimalActive = true
//            }
//                
//            if self.weight.decimalTwo != 0 {
//                digitLocation = .decimalTwo
//                decimalActive = true
//            }
            _weight.wrappedValue
        } set: { newValue in
            _weight.wrappedValue = newValue
        }
    }
    var weight: Weight { _weight.wrappedValue }
    var digitLocation: Weight.DigitLocation = .whole
    var decimalActive: Bool = false
    
    init(weight: Binding<Weight>) {
        self._weight = weight
        
        update()
    }
    
    mutating private func update() {
        if self.weight.decimalOne != 0  {
            digitLocation = .decimalOne
            decimalActive = true
        }
            
        if self.weight.decimalTwo != 0 {
            digitLocation = .decimalTwo
            decimalActive = true
        }
    }
    
    
    static func == (lhs: WeightKeyboard, rhs: WeightKeyboard) -> Bool {
        lhs.weight == rhs.weight &&
        lhs.digitLocation == rhs.digitLocation &&
        lhs.decimalActive == rhs.decimalActive
    }
}
