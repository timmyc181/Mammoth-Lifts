//

import SwiftUI


struct EditWeightView: View {
    @Binding var weight: Weight
    var increment: Weight
    
    @State private var weightText: String
    
    init(weight: Binding<Weight>, increment: Weight) {
        self._weight = weight
        self.increment = increment
        self._weightText = State(initialValue: String(weight.wrappedValue))
    }
    
//    @State private var decimalActive: Bool? = nil
//    @State private var _weightComponents: WeightKeyboard.WeightComponents
    
//    private var weightComponents: Binding<WeightKeyboard.WeightComponents> {
//        Binding {
//            if _weightComponents.number != weight {
//                WeightKeyboard.WeightComponents(weight: weight)
//            } else {
//                _weightComponents
//            }
//        } set: { components in
//            weight = components.number
////            weight = components.getWeight()
////            decimalActive = components.decimalActive
//        }
//
//    }
    
    var body: some View {
        VStack {
            WeightKeyboardWeightView(weight: $weight, weightText: weightText, increment: increment)
                .padding(.bottom, 40)
            WeightKeyboardView(weight: $weight, weightText: $weightText)
                .frame(height: 250)
            
        }
    }
}


struct EditWeightPreferenceKey: PreferenceKey {
    typealias Value = (weight: Binding<Weight>, increment: Weight, isPresented: Binding<Bool>)?
    
    static var defaultValue: Value = nil
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        if let nextValue = nextValue(),
           nextValue.isPresented.wrappedValue == true {
            value = nextValue
        }
    }
}

extension View {
    func editWeight(_ weight: Binding<Weight>, increment: Weight, isPresented: Binding<Bool>) -> some View {
        preference(
            key: EditWeightPreferenceKey.self,
            value: (weight, increment, isPresented)
        )
    }
}





//
//fileprivate struct WKPreview: View {
//    @State private var weight: Weight = 200
//    @State private var visible: Bool = true
//    
//    var body: some View {
//        WeightKeyboardOverlay(weight: $weight, increment: 2.5)
//            .background(Color.red)
//
//    }
//}
//
//#Preview {
//    WKPreview()
//}
