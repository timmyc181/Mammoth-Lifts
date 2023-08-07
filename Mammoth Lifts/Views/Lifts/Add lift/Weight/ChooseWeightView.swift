//
//  ChooseWeightView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/17/23.
//

import SwiftUI

struct ChooseWeightView: View {
    @Bindable var lift: Lift

    @State var pickerPosition: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                ChooseWeightScrollView(weight: $lift.currentWeight)

                VStack {
                    Spacer()
                    
                    ChooseWeightTextView(weight: lift.currentWeight)

                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: 4, height: 100)
                        .background(alignment: .bottom) {
                            LinearGradient(colors: [.clear, .sheetBackground, .sheetBackground, .clear], startPoint: .leading, endPoint: .trailing)
                                .frame(width: 100, height: 30)
                                .offset(y: 15)
                                
                        }
                    
                    Spacer()
                }
                .allowsHitTesting(false)

            }
            .ignoresSafeArea(edges: .horizontal)

            .coordinateSpace(.named("chooseWeight"))
            .ignoresSafeArea(edges: .horizontal)

            .sensoryFeedback(.selection, trigger: lift.currentWeight)
        }
        .ignoresSafeArea(edges: .horizontal)

        
    }
}

#Preview {
    AddLiftPreviewView(state: .weight)

}


