//
//  SheetView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/15/23.
//

import SwiftUI

struct SheetView<Content: View>: View {
    @Binding var isPresented: Bool
    var dragIndicator: Bool = false
    @ViewBuilder var content: Content
    
    @Environment(\.navigation) var navigation
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            
            
//            let gesture = DragGesture(minimumDistance: 0, coordinateSpace: .global)
//                .onChanged { gesture in
////                            let newOffset = Common.rubberBandClamp(gesture.translation.height, coeff: 0.2, dim: geo.size.height)
//                    let newOffset = max(gesture.translation.height, 0)
//                    withAnimation(.snappy(duration: 0.1)) {
//                        offset = newOffset
//                        navigation.sheetPresentationAmount = 1 - (newOffset / geo.size.height)
//                    }
//                }
//                .onEnded { gesture in
//                    let closeThreshold = geo.size.height / 3
//                    if gesture.predictedEndTranslation.height > closeThreshold {
//                        isPresented = false
//                        navigation.sheetPresentationAmount = 1
//
//                    } else {
//                        // Bounce is based on ending velocity
//                        let velocityMagnitude = sqrt(pow(gesture.velocity.width, 2) + pow(gesture.velocity.height, 2))
//                        let bounce = min(velocityMagnitude / 10000, 0.3)
//                        let animation = Animation.spring(duration: 0.3, bounce: bounce)
//                        var transaction = Transaction(animation: animation)
//                        transaction.disablesAnimations = true
//                        withTransaction(transaction) {
//                            offset = 0
//                            navigation.sheetPresentationAmount = 1
//                        }
//                    }
//                }
            
            let gesture = DragGesture.sheetDragGesture(
                offset: $offset,
                isPresented: $isPresented,
                closeThreshold: geo.size.height / 3.0) { newOffset in
                    navigation.sheetPresentationAmount = 1 - (newOffset / geo.size.height)
                } reset: {
                    navigation.sheetPresentationAmount = 1
                } close: {
                    navigation.sheetPresentationAmount = 1
                }
            
            
            ZStack {
                ScreenRectangle(fill: .sheetBackground)
                    .overlay(alignment: .top) {
                        if dragIndicator {
                            SheetDragIndicator()
                                .safeAreaPadding(.top, geo.safeAreaInsets.top + 5)
                        }
                        
                    }
                    .offset(y: offset)
                    .ignoresSafeArea(.all)
                    .gesture(gesture, including: navigation.sheetGestureEnabled ? .all : .subviews)

                VStack {
                    Spacer(minLength: 0)
                    content
                        .safeAreaPadding(.top, 20)
                        .safeAreaPadding(.bottom, 30)


                    Spacer(minLength: 0)
                }
                .offset(y: offset)
            }
            .onChange(of: navigation.sheetPresented) { oldValue, newValue in
                if newValue {
                    offset = 0
                }
            }
//            .gesture(gesture, including: navigation.sheetGestureEnabled ? .all : .all)
        }
        .transition(.moveIncludeSafeArea)
//        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))

    }
}


extension AnyTransition {
    static var moveIncludeSafeArea: AnyTransition { get {
        AnyTransition.modifier(
            active: MoveIncludeSafeArea(value: 0),
            identity: MoveIncludeSafeArea(value: 1))
        }
    }
}

struct MoveIncludeSafeArea: ViewModifier {
    let value: Double
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                content.offset(y: value == 0 ? geo.size.height + geo.safeAreaInsets.bottom : 0)

            }
        }
    }
}




#Preview {
    ContentView()
}
