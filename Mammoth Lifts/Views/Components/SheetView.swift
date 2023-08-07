//
//  SheetView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/15/23.
//

import SwiftUI

struct SheetView<Content: View>: View {
    @Binding var isPresented: Bool
    @ViewBuilder var content: Content
    
    @Environment(\.navigation) var navigation
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ScreenRectangle(fill: .sheetBackground)
                    .offset(y: offset)
                    .ignoresSafeArea(.all)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            let newOffset = Common.rubberBandClamp(gesture.translation.height, coeff: 0.2, dim: geo.size.height)
                            withAnimation(.snappy(duration: 0.1)) {
                                offset = newOffset
                                navigation.sheetPresentationAmount = 1 - (offset / geo.size.height)
                            }
                        }
                        .onEnded { gesture in
                            let closeThreshold = geo.size.height / 3
                            if gesture.predictedEndTranslation.height > closeThreshold {
                                navigation.addLiftPresented = false
                                navigation.sheetPresentationAmount = 1
                            } else {
                                withAnimation(.smooth(duration: 0.3)) {
                                    offset = 0
                                    navigation.sheetPresentationAmount = 1
                                }
                            }
                        }, including: navigation.sheetGestureEnabled ? .all : .subviews)

                VStack {
                    Spacer(minLength: 0)
                    content
                    Spacer(minLength: 0)
                }
                .offset(y: offset)


            }
            .onChange(of: navigation.sheetPresented) { oldValue, newValue in
                if newValue {
                    offset = 0
                }
            }
        }
        .transition(.move(edge: .bottom))
//        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))

    }
}
