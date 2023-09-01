//

import SwiftUI

struct WeightKeyboard: View {
    @Binding var weightComponents: WeightComponents
    
    @State private var decimalActive = false

    
    struct WeightComponents: Equatable {
        var whole: [Int]
        var decimal: [Int]
        var decimalActive: Bool = false
        
        init(whole: [Int], decimal: [Int]) {
            self.whole = whole
            self.decimal = decimal
            self.decimalActive = decimal.count > 0
        }
        
        init(weight: Double, decimalActive: Bool?) {
            let weightString = weight.clean
            let components = weightString.components(separatedBy: ".")

            var whole = components[0].compactMap{ $0.wholeNumberValue }
            if whole == [0] {
                whole = []
            }

            var decimal: [Int] = []
            if components.count == 2 {
                decimal = components[1].compactMap{ $0.wholeNumberValue }
            }
            
            let decimalsExist = decimal.count > 0
            
            self.whole = whole
            self.decimal = decimal
            self.decimalActive = decimalsExist ? true : decimalActive ?? false
        }
        
        public func getWeight() -> Double {
            var string: String
            if whole.count > 0 {
                 string = whole.map{String($0)}.joined(separator: "")
            } else {
                string = "0"
            }
            if decimal.count > 0 {
                string += "." + decimal.map{String($0)}.joined(separator: "")
            }
            return Double(string) ?? -10.0
        }
        
        
    }

        
    
    var body: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 15) {
            GridRow {
                WeightKeyboardButton(action: .number(1), onTap: onTap)
                WeightKeyboardButton(action: .number(2), onTap: onTap)
                WeightKeyboardButton(action: .number(3), onTap: onTap)
                
            }

            GridRow {
                WeightKeyboardButton(action: .number(4), onTap: onTap)
                WeightKeyboardButton(action: .number(5), onTap: onTap)
                WeightKeyboardButton(action: .number(6), onTap: onTap)
                
            }
            
            GridRow {
                WeightKeyboardButton(action: .number(7), onTap: onTap)
                WeightKeyboardButton(action: .number(8), onTap: onTap)
                WeightKeyboardButton(action: .number(9), onTap: onTap)
            }

            GridRow {
                WeightKeyboardButton(action: .period, onTap: onTap)
                WeightKeyboardButton(action: .number(0), onTap: onTap)
                WeightKeyboardButton(action: .delete, onTap: onTap)

            }

        }
        .frame(height: 230)

    }
    
    @ViewBuilder private func keyboard() -> some View {
        
    }
    
    private func onTap(_ action: WeightKeyboardAction) {
        switch action {
        case .number(let number):
            if weightComponents.decimalActive || weightComponents.decimal.count > 0 {
                if weightComponents.decimal.count < 2 {
                    weightComponents.decimal.append(number)
                }
            } else {
                if weightComponents.whole.count < 3 {
                    weightComponents.whole.append(number)
                }

            }
        case .period:
            weightComponents.decimalActive.toggle()
        case .delete:
//            weightComponents.decimalActive = false
            if weightComponents.decimal.count == 0 {
                if weightComponents.decimalActive {
                    weightComponents.decimalActive = false
                } else if weightComponents.whole.count >= 1 {
                    weightComponents.whole.removeLast()
                }
            } else {
                weightComponents.decimal.removeLast()
            }
        }
    }
}

fileprivate enum WeightKeyboardAction {
    case number(Int)
    case period
    case delete
}


fileprivate struct WeightKeyboardButton: View {
    var action: WeightKeyboardAction
    
    var onTap: (WeightKeyboardAction) -> ()
    
    var fontSize: CGFloat = 26
    
    var body: some View {
        Button {
            onTap(action)
        } label: {
            Group {
                switch action {
                case .number(let number):
                    Text(String(number))
                        .customFont(size: fontSize)
                case .period:
                    Text(".")
                        .customFont(size: fontSize)
                case .delete:
                    Image(systemName: "delete.left")
                        .fontWeight(.semibold)
                        .font(.system(size: fontSize))
                        .foregroundStyle(Color.white)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            

        }
        .buttonRepeatBehavior(.enabled)

    }
}



#Preview {
    ZStack {
        Color.background.ignoresSafeArea()
        WeightKeyboardPreview()
            .colorScheme(.dark)
    }

}

struct WeightKeyboardPreview: View {
    @State private var weight: Double = 100
    
    @State private var weightComponents: WeightKeyboard.WeightComponents = .init(whole: [4], decimal: []) {
        willSet {


        }
    }
    
    var body: some View {
        VStack {
            Text(String(weight.clean))
                .customFont(size: 30)
            WeightKeyboard(weightComponents: $weightComponents)
        }
        
        .background {
            Color(.smallSheetBackground)
        }
    }
}
