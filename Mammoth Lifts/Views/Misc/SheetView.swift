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
    
    @Environment(Navigation.self) var navigation
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ScreenRectangle(fill: .background)
                    .offset(y: offset)
                    .ignoresSafeArea(.all)
                VStack {
//                    RoundedRectangle(cornerRadius: 3, style: .circular)
//                        .fill(.white.opacity(0.2))
//                        .frame(width: 35, height: 6)
//                        .padding(.top, 5)
//                        .padding(.bottom)
                    Spacer(minLength: 0)
                    content
                        .padding(.horizontal, Constants.pagePadding)
                    Spacer(minLength: 0)
                }
                .offset(y: offset)


            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let newOffset = rubberBandClamp(gesture.translation.height, coeff: 0.2, dim: geo.size.height)
                        offset = newOffset
                        navigation.sheetPresentationAmount = 1 - (offset / geo.size.height)
                    }
                    .onEnded { gesture in
                        let closeThreshold = geo.size.height / 3
                        if gesture.predictedEndTranslation.height > closeThreshold {
                            navigation.addLiftPresented = false
                            navigation.sheetPresentationAmount = 1
                        } else {
                            withAnimation(.smooth(duration: 0.4)) {
                                offset = 0
                                navigation.sheetPresentationAmount = 1
                            }
                        }
                    }
            )
            .onChange(of: navigation.sheetPresented) { oldValue, newValue in
                if newValue {
                    offset = 0
                }
            }
        }
        .transition(.move(edge: .bottom))
//        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))

    }
    
    private func rubberBandClamp(_ x: CGFloat, coeff: CGFloat, dim: CGFloat) -> CGFloat {
        let clampedX = max(x, 0)
        let diff = abs(x - clampedX)
        let sign: CGFloat = clampedX > x ? -1 : 1
        
        return clampedX + sign * (1.0 - (1.0 / ((diff * coeff / dim) + 1.0))) * dim
    }
}
