//
//  ChooseWeightTicksView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/18/23.
//

import Foundation
import SwiftUI

struct ChooseWeightMarkersView: View {
    let maxWeight: Int = 1000
    
    static let spacing: CGFloat = 15
    static let tickWidth: CGFloat = 4
    
    static let totalTickWidth = spacing + tickWidth
    
    var body: some View {
        LazyHStack(alignment: .bottom, spacing: 0) {
                ForEach(0..<maxWeight) { increment in
                    
                    let isWhole = increment % 5 == 0
                    
                    let isKeyMarker = increment % 10 == 0
                    
                    Rectangle()
                        .fill(.white.opacity(isWhole ? 0.8 : 0.2))
                        .frame(width: Self.tickWidth, height: isWhole ? 60 : 40)
                        .id(increment)
                        .padding(.horizontal, Self.spacing / 2)
                        .overlay(alignment: .bottom) {
                            if isKeyMarker {
                                Text("\(increment)")
                                    .customFont()
                                    .frame(maxWidth: .infinity)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .opacity(0.2)

                                    .offset(y: 30)


                            }
                        }

                }

            }
            .frame(height: 60)
            .overlay {
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: ScrollPreferenceKey.self,
                            value: -geo.frame(in: .named("chooseWeight")).minX
                        )
                }
            }

    }
}

struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


#Preview {
    ZStack {
        Color.sheetBackground
            .ignoresSafeArea()
        AddLiftView()
            .environment(Navigation())
            .environment(AddLiftState())
//            .coordinateSpace(.named("container"))
    }
}
