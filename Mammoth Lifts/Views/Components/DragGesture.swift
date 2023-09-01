import Foundation
import SwiftUI



extension DragGesture {
    public static func sheetDragGesture(offset: Binding<CGFloat>, padding: Binding<CGFloat>? = nil, isPresented: Binding<Bool>, closeThreshold: CGFloat, onChange: ((CGFloat) -> ())? = nil, reset: (() -> ())? = nil, close: (() -> ())? = nil) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { gesture in
                let newOffset = max(gesture.translation.height, 0)
                withAnimation(.snappy(duration: 0.1)) {
                    offset.wrappedValue = newOffset
                    if newOffset == 0 {
                        padding?.wrappedValue = -Common.rubberBandClamp(gesture.translation.height, coeff: 0.35, dim: 100,  range: 0...(.infinity))
                    } else {
                        padding?.wrappedValue = 0
                    }
                    onChange?(newOffset)
                }
            }
            .onEnded { gesture in
                if gesture.predictedEndTranslation.height > closeThreshold {
                    // Gesture passes threshold, close
                    isPresented.wrappedValue = false
                    padding?.wrappedValue = 0
                    close?()
                    



                } else {
                    // Gesture does not pass threshold, reset

                    if let padding = padding,
                       padding.wrappedValue > 0 {
                        let animation = Constants.sheetPresentationStiffAnimation
                        var transaction = Transaction(animation: animation)
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            print("transaction")
//                            isPresented.wrappedValue = false
                            offset.wrappedValue = 0
                            padding.wrappedValue = 0
                            close?()
                        }
                    } else {
                        // Bounce is based on ending velocity
                        
                        let velocityMagnitude = sqrt(pow(gesture.velocity.width, 2) + pow(gesture.velocity.height, 2))
                        let bounce = min(velocityMagnitude / 10000, 0.3)
                        let animation = Animation.spring(duration: 0.3, bounce: bounce)
                        var transaction = Transaction(animation: animation)
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            offset.wrappedValue = 0
                            padding?.wrappedValue = 0
                            reset?()
                        }
                    }
                    
                }
            }
        
//            .onEnded { gesture in
//                if gesture.predictedEndTranslation.height > closeThreshold {
////                    isPresented = false
////                    offsetPadding = 0
//                } else {
//                    withAnimation(.smooth(duration: 0.4)) {
//                        offset = 0
//                        offsetPadding = 0
//                    }
//                }
//            }
    }
}


