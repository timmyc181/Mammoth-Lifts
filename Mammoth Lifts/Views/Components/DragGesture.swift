import Foundation
import SwiftUI



extension DragGesture {
    public struct Detents: Equatable {
        var offset: Binding<CGFloat>
        var extraDetents: [CGFloat]
        
        var highestDetentOffset: CGFloat {
            let highest = extraDetents.max() ?? 0
            return -max(0, highest)
        }
        
        
        public static func == (lhs: DragGesture.Detents, rhs: DragGesture.Detents) -> Bool {
            lhs.extraDetents == rhs.extraDetents && lhs.offset.wrappedValue == rhs.offset.wrappedValue
        }
        
    }
    
    public static func sheetDragGesture(offset: Binding<CGFloat>, padding: Binding<CGFloat>? = nil,
                                        isPresented: Binding<Bool>, sheetHeight: CGFloat,
                                        detents: Detents? = nil, initialOffset: Binding<CGFloat?>,
                                        onChange: ((CGFloat) -> ())? = nil, reset: (() -> ())? = nil,
                                        close: (() -> ())? = nil) -> some Gesture {
        
        var totalOffset: Binding<CGFloat> {
            Binding {
                offset.wrappedValue - (padding?.wrappedValue ?? 0) - (detents?.offset.wrappedValue ?? 0)
            } set: { newValue in
                let newOffset = max(newValue, 0)

                offset.wrappedValue = newOffset
                if let detents = detents {
                    if newOffset == 0 {
                        let lowerOffsetBound = detents.highestDetentOffset
                        detents.offset.wrappedValue = -Common.rubberBandClamp(newValue, coeff: 0.35, dim: 100,  range: lowerOffsetBound...(.infinity))
                    } else {
                        detents.offset.wrappedValue = 0
                    }
                } else {
                    if newOffset == 0 {
//                        let lowerOffsetBound = detents?.highestDetentOffset ?? 0
                        padding?.wrappedValue = -Common.rubberBandClamp(newValue, coeff: 0.35, dim: 100,  range: 0...(.infinity))
                    } else {
                        padding?.wrappedValue = 0
                    }
                }
                
                onChange?(newOffset)
            }

        }
        
        func getThresholds() -> [Range<CGFloat>: CGFloat] {
            var offsets: [CGFloat] = [
                sheetHeight,
                0
            ]
            
            if let detents = detents {
                offsets.append(contentsOf:
                                detents.extraDetents.map {
                                    -$0
                                }
                )
            }
            
            offsets.sort()
            
            var dict = [Range<CGFloat>: CGFloat]()
            
            for (i, offset) in offsets.enumerated() {
                let lowerBound: CGFloat
                if i == 0 {
                    lowerBound = -.infinity
                } else {
                    // Make midpoint
                    lowerBound = (offsets[i - 1] + offset) / 2
                }
                
                let upperBound: CGFloat
                if i == offsets.count - 1 {
                    upperBound = .infinity
                } else {
                    // Make midpoint
                    upperBound = (offsets[i + 1] + offset) / 2
                }
                
                
                dict[lowerBound..<upperBound] = offset
                
            }
            
            return dict
        }
        
        return DragGesture(minimumDistance: 1, coordinateSpace: .global)
            .onChanged { gesture in
                let addToTranslation: CGFloat
                if let unwrappedInitialOffset = initialOffset.wrappedValue {
                    addToTranslation = unwrappedInitialOffset
                } else {
                    initialOffset.wrappedValue = totalOffset.wrappedValue
                    addToTranslation = totalOffset.wrappedValue
                }
//                withAnimation(.snappy(duration: 0.1)) {
                var transaction = Transaction()
//                transaction.disablesAnimations = true
                transaction.isContinuous = true
                transaction.animation = .snappy(duration: 0.1)
                withTransaction(transaction) {
                    
//                }
                    totalOffset.wrappedValue = gesture.translation.height + addToTranslation
                }
            }
            .onEnded { gesture in
                
                
                let gestureEndTranslation = gesture.predictedEndTranslation.height
                
                let thresholds = getThresholds()
                var shouldClose: Bool = false
                var toOffset: CGFloat = 0
                
                let sortedKeys = thresholds
                    .keys
                    .sorted { thresholds[$0]! < thresholds[$1]! }
                    .enumerated()

                let predictedOffset = gestureEndTranslation + (initialOffset.wrappedValue ?? 0) 
                
                for (i, threshold) in sortedKeys {
                    if threshold.contains(predictedOffset) {
                        // Close if first element
                        
                        toOffset = thresholds[threshold]!
                        shouldClose = i == thresholds.count - 1
                        
                        let skippedTwo = totalOffset.wrappedValue <= 0 && shouldClose
                        
                        if skippedTwo {
                            shouldClose = false
                            toOffset = 0
                        }
                        
                        break
                    }
                }
                
                
                if shouldClose {
                    isPresented.wrappedValue = false
//                    padding?.wrappedValue = 0
                    close?()
                } else {
                    // If rubberband snap back, do different animation
                    // highestHeightOffset is negative, since it's an offset
                    
                    if totalOffset.wrappedValue < (detents?.highestDetentOffset ?? 0) {
                        let animation = Constants.sheetPresentationStiffAnimation
                        var transaction = Transaction(animation: animation)
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            totalOffset.wrappedValue = toOffset
                            close?()
                        }
                    } else {
                        // Bounce is based on ending velocity
                        
//                        var transaction = Transaction()
//        //                transaction.disablesAnimations = true
//                        transaction.isContinuous = true
//                        
//                        print(velocity)
//                        
//                        let dampingFraction = 0.9 - (velocity / 10000)
//                        
//                        transaction.animation = .spring(response: 0.3, dampingFraction: dampingFraction)
//                        withTransaction(transaction) {
//                            if gestureEndTranslation < -150 {
//                                detents!.offset.wrappedValue = detents!.extraDetents[0]
//                            } else {
//                                detents!.offset.wrappedValue = 0
//
//                            }
//                        }
                        let velocity = abs(gesture.velocity.height)

                        let bounce = min(velocity / 8000, 0.3)
                        let animation = Animation.spring(duration: 0.3, bounce: bounce)
                        var transaction = Transaction(animation: animation)
                        transaction.disablesAnimations = true
                        transaction.isContinuous = true
                        withTransaction(transaction) {
                            totalOffset.wrappedValue = toOffset
                            reset?()
                        }
                    }
                    
                    initialOffset.wrappedValue = nil
                }
            }
    }
}








struct SheetDragGestureModifier: ViewModifier {
    var offset: Binding<CGFloat>
    var padding: Binding<CGFloat>? = nil
    var isPresented: Binding<Bool>
    var sheetHeight: CGFloat
    var onChange: ((CGFloat) -> ())? = nil
    var reset: (() -> ())? = nil
    var close: (() -> ())? = nil
    
    @State var initialOffset: CGFloat? = nil
    @State var detents: DragGesture.Detents? = nil
    
    @State private var defaultSheetHeight: CGFloat? = nil
    
    @State private var initialTranslation: CGFloat = 0
    
    var totalOffset: Binding<CGFloat> {
        Binding {
            offset.wrappedValue - (padding?.wrappedValue ?? 0) - (detents?.offset.wrappedValue ?? 0)
        } set: { newValue in
            let newValue = newValue - initialTranslation
            let newOffset = max(newValue, 0)
            
            print("newVal: ", newValue, ", newOffset: ", newOffset, " initialTrans: ", initialTranslation)
            
            offset.wrappedValue = newOffset
            if let detents = detents {
                if newOffset == 0 {
                    let lowerOffsetBound = detents.highestDetentOffset
                    detents.offset.wrappedValue = -Common.rubberBandClamp(newValue, coeff: 0.35, dim: 100,  range: lowerOffsetBound...(.infinity))
                } else {
                    detents.offset.wrappedValue = 0
                }
            } else {
                if newOffset == 0 {
                    //                        let lowerOffsetBound = detents?.highestDetentOffset ?? 0
                    padding?.wrappedValue = -Common.rubberBandClamp(newValue, coeff: 0.35, dim: 100,  range: 0...(.infinity))
                } else {
                    padding?.wrappedValue = 0
                }
            }
            
            onChange?(newOffset)
        }
    }
    
    public struct Detents: Equatable {
        var offset: Binding<CGFloat>
        var extraDetents: [CGFloat]
        
        var highestDetentOffset: CGFloat {
            let highest = extraDetents.max() ?? 0
            return -max(0, highest)
        }
        
        
        public static func == (lhs: SheetDragGestureModifier.Detents, rhs: SheetDragGestureModifier.Detents) -> Bool {
            lhs.extraDetents == rhs.extraDetents && lhs.offset.wrappedValue == rhs.offset.wrappedValue
        }
        
    }
    
    func getThresholds() -> [Range<CGFloat>: CGFloat] {
        var offsets: [CGFloat] = [
            sheetHeight,
            0
        ]
        
        if let detents = detents {
            offsets.append(contentsOf:
                            detents.extraDetents.map {
                                -$0
                            }
            )
        }
        
        offsets.sort()
        
        var dict = [Range<CGFloat>: CGFloat]()
        
        for (i, offset) in offsets.enumerated() {
            let lowerBound: CGFloat
            if i == 0 {
                lowerBound = -.infinity
            } else {
                // Make midpoint
                lowerBound = (offsets[i - 1] + offset) / 2
            }
            
            let upperBound: CGFloat
            if i == offsets.count - 1 {
                upperBound = .infinity
            } else {
                // Make midpoint
                upperBound = (offsets[i + 1] + offset) / 2
            }
            
            
            dict[lowerBound..<upperBound] = offset
            
        }
        
        return dict
    }
    
    var sheetUnderlayOpacity: CGFloat {
        if let defaultSheetHeight = defaultSheetHeight {
            let val = offset.wrappedValue / defaultSheetHeight
            return min(max(1 - val, 0), 1)
        }
        return 0
    }
    
    @State private var a: Bool = false

    func body(content: Content) -> some View {
        content
//            .disabled(offset.wrappedValue != 0)
            .highPriorityGesture(
                DragGesture(minimumDistance: 1, coordinateSpace: .global)
                    .onChanged { gesture in
                        let addToTranslation: CGFloat
                        if let unwrappedInitialOffset = initialOffset {
                            addToTranslation = unwrappedInitialOffset
                        } else {
                            initialTranslation = gesture.translation.height
                            initialOffset = totalOffset.wrappedValue
                            addToTranslation = totalOffset.wrappedValue
                        }
        //                withAnimation(.snappy(duration: 0.1)) {
                        var transaction = Transaction()
        //                transaction.disablesAnimations = true
                        transaction.isContinuous = true
                        transaction.animation = .snappy(duration: 0.1)
//                        withTransaction(transaction) {
                            
        //                }
                            totalOffset.wrappedValue = gesture.translation.height + addToTranslation
//                        }
                    }
                    .onEnded { gesture in
                        
                        let gestureEndTranslation = gesture.predictedEndTranslation.height
                        
                        let thresholds = getThresholds()
                        var shouldClose: Bool = false
                        var toOffset: CGFloat = 0
                        
                        let sortedKeys = thresholds
                            .keys
                            .sorted { thresholds[$0]! < thresholds[$1]! }
                            .enumerated()

                        let predictedOffset = gestureEndTranslation + (initialOffset ?? 0)
                        
                        for (i, threshold) in sortedKeys {
                            if threshold.contains(predictedOffset) {
                                // Close if first element
                                
                                toOffset = thresholds[threshold]!
                                shouldClose = i == thresholds.count - 1
                                
                                let skippedTwo = totalOffset.wrappedValue <= 0 && shouldClose
                                
                                if skippedTwo {
                                    shouldClose = false
                                    toOffset = 0
                                }
                                
                                break
                            }
                        }
                        
                        
                        if shouldClose {
                            isPresented.wrappedValue = false
        //                    padding?.wrappedValue = 0
                            close?()
                        } else {
                            // If rubberband snap back, do different animation
                            // highestHeightOffset is negative, since it's an offset
                            
                            if totalOffset.wrappedValue < (detents?.highestDetentOffset ?? 0) {
//                                let animation = Constants.sheetPresentationStiffAnimation
                                let velocity = gesture.velocity.height
                                let initialVelocity = gesture.velocity.height
                                
                                let animation = Animation.interpolatingSpring(duration: 5.3, bounce: 0.2, initialVelocity: initialVelocity)
                                
                                var transaction = Transaction(animation: .snappy)
//                                transaction.disablesAnimations = true
                                
                                withTransaction(transaction) {
                                    initialTranslation = 0
                                    totalOffset.wrappedValue = toOffset
//                                    offset.wrappedValue = 200
                                    close?()
                                }
                            } else {
                                // Bounce is based on ending velocity
//                                let velocity = abs(gesture.velocity.height)

//                                let bounce = min(velocity / 8000, 0.3)
//                                var animation = Animation.spring(duration: 0.3, bounce: bounce)
                                let velocity = gesture.velocity.height
                                let initialVelocity = abs(velocity) / 100
                                
                                print(initialVelocity)
                                
                                self.a.toggle()
                                
                                var bounce = 0.05
                                
                                if initialVelocity > 3 {
                                    print("!!!, \(initialVelocity)")
                                    bounce = 0.2
                                }
                                
                                let animation = Animation//.interpolatingSpring(duration: 0.3, bounce: 0.2, initialVelocity: initialVelocity)
                                
                                    .interpolatingSpring(
//                                        mass: 1.2,
//                                        stiffness: 200,
//                                        damping: 25,
                                        duration: 0.35,
                                        bounce: bounce,
                                        initialVelocity: initialVelocity
                                    )
                                
                                var transaction = Transaction(animation: .snappy)
//                                transaction.disablesAnimations = true
//                                transaction.isContinuous = true
                                withTransaction(transaction) {
                                    initialTranslation = 0
                                    totalOffset.wrappedValue = toOffset
//                                    offset.wrappedValue = 200

                                    reset?()
                                }
                            }
                            
                            initialOffset = nil
                        }
                    }
            )
            .onPreferenceChange(SheetDetentsPreferenceKey.self) { value in
                detents = value
            }
            .preference(key: SheetUnderlayOpacityKey.self, value: sheetUnderlayOpacity)
            .background {
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            defaultSheetHeight = geo.size.height
                        }
                }
            }
//            .overlay {
//                Color.red
//                    .frame(width: 30, height: 30)
//                    .opacity(a ? 1 : 0.2)
//                    .allowsHitTesting(false)
//            }
    }
    
    
}

extension View {
    public func sheetDragGesture(offset: Binding<CGFloat>, padding: Binding<CGFloat>? = nil,
                                 isPresented: Binding<Bool>, sheetHeight: CGFloat,
                                 onChange: ((CGFloat) -> ())? = nil, reset: (() -> ())? = nil,
                                 close: (() -> ())? = nil) -> some View {
        modifier(
            SheetDragGestureModifier(
                offset: offset,
                padding: padding,
                isPresented: isPresented,
                sheetHeight: sheetHeight,
                onChange: onChange,
                reset: reset,
                close: close
            )
        )
    }
    
    
    public func sheetDetents(_ detents: [CGFloat], offset: Binding<CGFloat>) -> some View {
        preference(key: SheetDetentsPreferenceKey.self, value: .init(offset: offset, extraDetents: detents))
    }
    
    public func sheetUnderlayOpacity(_ value: Binding<CGFloat>) -> some View {
        onPreferenceChange(SheetUnderlayOpacityKey.self) { newValue in
            value.wrappedValue = newValue
        }
    }
}


struct SheetDetentsPreferenceKey: PreferenceKey {
    static var defaultValue: DragGesture.Detents? = nil
    
    static func reduce(value: inout DragGesture.Detents?, nextValue: () -> DragGesture.Detents?) {
        value = nextValue()

    }
}

struct SheetUnderlayOpacityKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()

    }
}

#Preview {
    ContentView()
        .populatedPreviewContainer()
}
