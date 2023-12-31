//
//  LiftItemView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/12/23.
//

import SwiftUI
import SwiftData

struct LiftItemView: View {
    let lift: Lift
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.navigation) private var navigation
    
    private let squareSize: CGSize = .init(width: 50, height: 50)
    
    @State private var size: CGSize = .init(width: 100, height: 20)
    
    @State private var offset: CGFloat = 0
    
    @State private var pressed = false
    
    var totalOffset: CGFloat {
        Common.rubberBandClamp(offset, coeff: 0.55, dim: size.width, range: 0...0)
    }
    
    let logLiftDragThreshold: CGFloat = 60

    var body: some View {
        ZStack(alignment: .leading) {
            if totalOffset != 0 {
                let unclampedAmount = (totalOffset * 2) / logLiftDragThreshold - 1
                let amount = max(min((unclampedAmount), 1), 0)
                
                ZStack {
                    if amount == 1 {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                    } else {
                        let lineWidth: CGFloat = 3
                        Circle()
                            .trim(from: 0, to: amount)
                            .stroke(
                                Color.white.opacity(0.1),
                                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                            )
                            .padding(lineWidth / 2)
                            .rotationEffect(.degrees(-90))
                    }
                   
                    Image(systemName: "list.bullet")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .scaleEffect(amount)
                        .frame(width: 20, height: 20)

                }
                .frame(width: 36, height: 36)
                .opacity(amount)
                .offset(x: min(totalOffset, logLiftDragThreshold) / 4 - 10)
                .transaction { transaction in
                    transaction.animation = nil
                }
            }


            Button {
                navigation.liftForDetails = lift
            } label: {
                HStack(spacing: 8) {
                    LiftItemIconView(name: lift.name)
                        .frame(width: squareSize.width, height: squareSize.height)
                    
                    LiftItemDetailsView(name: lift.name, weight: lift.currentWeight, lastCompleted: "Last Friday")
                    
                    Spacer(minLength: 0)
                    
                    LiftItemButtonView()
                        .frame(width: squareSize.width, height: squareSize.height)
                    
                }
            }
            .buttonStyle(LiftItemButtonStyle())
            

            
            .backgroundSizingPreference()
            .onPreferenceChange(BackgroundPreferenceKey.self, perform: { size in
                self.size = size
            })
            
            .offset(x: totalOffset)
            .highPriorityGesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { value in
                        pressed = true
                        withAnimation(.snappy(duration: 0.1)) {
                            offset = value.translation.width
                        }

                    }
                    .onEnded{ value in
                        pressed = false
                        
                        // Simulate press
//                        if totalOffset == 0 {
//                            navigation.liftForDetails = lift
//                        }
                        
                        if totalOffset >= logLiftDragThreshold {
                            withAnimation(.snappy) {
                                
                                offset = 0
                            }
                            navigation.liftToLog = lift
                        } else {
                            withAnimation(.snappy) {
                                offset = 0
                            }
                        }

                    }
            )
            
            .sensoryFeedback(.impact, trigger: totalOffset >= logLiftDragThreshold) { oldValue, newValue in
                return !navigation.logWorkoutPresented || newValue
            }
            
        }
        
    }
}

#Preview {
    ZStack {
        LiftItemPreviewView { lifts in
            LiftItemView(lift: lifts.first!)

        }

    }
    .populatedPreviewContainer()
}

struct LiftItemPreviewView<Content: View>: View {
    @ViewBuilder var content: ([Lift]) -> Content
    
    @Query
    var lifts: [Lift]
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            if lifts.first != nil {
                content(lifts)
                    .safeAreaPadding(.horizontal, Constants.sidePadding)
            }
        }
        .populatedPreviewContainer()
    }
    
    
}


struct LiftItemButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(
                Color("CardBackground")
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: -2)
                    .cornerRadius(24)
            )
            .overlay {
                Color.white.opacity(configuration.isPressed ? 0.05 : 0)
            }
            .cornerRadius(24)
            .scaleEffect(configuration.isPressed ? 1.04 : 1)
            .animation(.smooth, value: configuration.isPressed)
    }
}





extension LinearGradient {
    static public var accent: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [Color("AccentGradientStart"), Color("AccentGradientEnd")]
            ),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
