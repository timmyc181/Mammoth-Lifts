//

import SwiftUI

struct WeightKeyboardView: View {
    @Binding var weight: Weight
    @Binding var weightText: String
    
    var height: CGFloat = 300
        
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 10) {
                WeightKeyboardButton(action: .number(1), onTap: onTap)
                WeightKeyboardButton(action: .number(2), onTap: onTap)
                WeightKeyboardButton(action: .number(3), onTap: onTap)
            }
            HStack(spacing: 10) {
                WeightKeyboardButton(action: .number(4), onTap: onTap)
                WeightKeyboardButton(action: .number(5), onTap: onTap)
                WeightKeyboardButton(action: .number(6), onTap: onTap)
            }
            HStack(spacing: 10) {
                WeightKeyboardButton(action: .number(7), onTap: onTap)
                WeightKeyboardButton(action: .number(8), onTap: onTap)
                WeightKeyboardButton(action: .number(9), onTap: onTap)
            }
            HStack(spacing: 10) {
                WeightKeyboardButton(action: .period, onTap: onTap)
                WeightKeyboardButton(action: .number(0), onTap: onTap)
                WeightKeyboardButton(action: .delete, onTap: onTap)
            }
        }
        .sensoryFeedback(.selection, trigger: weightText)
        .onChange(of: weight) { oldValue, newValue in
            if newValue != Weight(weightText) {
                weightText = String(newValue)
            }
        }
    }
    
    private func onTap(_ action: WeightKeyboardAction) {
        switch action {
        case .number(let number):
            let components = weightText.components(separatedBy: ".")
            if components.count == 1 {
                if components[0].count < 3 {
                    weightText += String(number)
                }
            } else if components[1].count < 2 {
                weightText += String(number)
            }
        case .period:
            if weightText.components(separatedBy: ".").count == 1 {
                weightText += "."
            }
        case .delete:
            if weightText.count > 0 {
                weightText.removeLast()
            }
        }
        weight = Weight(weightText)
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
    
    var fontSize: CGFloat = 30//26
    
    var body: some View {
//        Rectangle().fill(.background)
//            .opacity(0.01)
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



//#Preview {
//    ZStack {
//        Color.background.ignoresSafeArea()
//        WeightKeyboardPreview()
//            .colorScheme(.dark)
//    }
//
//}

//struct WeightKeyboardPreview: View {
//    @State private var weight: Weight = 100
//    @State private var keyboardWeight = KeyboardWeight()
//    
//    
//    var body: some View {
//        VStack {
//            Text(weight.text)
//                .customFont(size: 30)
//            WeightKeyboard(weight: $keyboardWeight)
//        }
//        
//        .background {
//            Color(.smallSheetBackground)
//        }
//    }
//}
