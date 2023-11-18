//

import SwiftUI

struct LogWorkoutKeyboardView: View {
    var height: CGFloat
    @Binding var weight: Weight
    @Binding var weightText: String
    
    private let finalHeight = LogWorkoutView.expandedSheetHeight - LogWorkoutView.finalBottomPadding
    
    private var keyboardExpandedAmount: CGFloat {
        height / LogWorkoutView.expandedSheetHeight
    }
    
    private var keyboardHeight: CGFloat {
        keyboardExpandedAmount * finalHeight
    }
    
    var body: some View {
//        VStack {
        WeightKeyboardView(weight: $weight, weightText: $weightText)
//                .padding(.bottom, 50)
//                .frame(height: finalHeight)
//        }
//        .weightKeyboardHeight(height)
//        .scaleEffect(y: keyboardExpandedAmount)
//        .opacity(keyboardExpandedAmount)
//        .frame(height: keyboardHeight)
        
    }
}

fileprivate struct WeightKeyboardHeight: ViewModifier {
    var height: CGFloat
    
    private let finalHeight = LogWorkoutView.expandedSheetHeight - LogWorkoutView.finalBottomPadding
    
    private var keyboardExpandedAmount: CGFloat {
        height / LogWorkoutView.expandedSheetHeight
    }
    
    private var keyboardHeight: CGFloat {
        keyboardExpandedAmount * finalHeight
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(y: keyboardExpandedAmount)
            .opacity(keyboardExpandedAmount)
            .frame(height: keyboardHeight)
    }
}


extension View {
    public func weightKeyboardHeight(_ height: CGFloat) -> some View {
        modifier(WeightKeyboardHeight(height: height))
    }
}


extension AnyTransition {
    static var weightKeyboard: AnyTransition {
        .modifier(
            active: WeightKeyboardHeight(height: 0),
            identity: WeightKeyboardHeight(height: LogWorkoutView.expandedSheetHeight - LogWorkoutView.finalBottomPadding)
        )
    }
}

//#Preview {
//    LogWorkoutKeyboardView()
//}
