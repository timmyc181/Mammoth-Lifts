//
//  ChooseWeightView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/17/23.
//

import SwiftUI

struct ChooseWeightView: View {
    @Environment(AddLiftState.self) var addLiftState: AddLiftState
    
    @State var pickerPosition: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                ChooseWeightScrollView()

                VStack {
                    Spacer()
                    
                    ChooseWeightTextView()
                    
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
            .coordinateSpace(.named("chooseWeight"))
            
            .onAppear {
                Constants.selectionFeedbackGenerator.prepare()
            }
            
            .onChange(of: addLiftState.lift?.currentWeight) { oldValue, newValue in
                Constants.selectionFeedbackGenerator.selectionChanged()
            }
        }
        
    }
}

#Preview {
    ZStack {
        Color.sheetBackground
            .ignoresSafeArea()
        AddLiftView()
            .environment(Navigation())
            .environment(AddLiftState())
    }
}


