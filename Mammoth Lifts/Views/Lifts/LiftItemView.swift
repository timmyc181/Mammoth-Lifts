//
//  LiftItemView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/12/23.
//

import SwiftUI

struct LiftItemView: View {
    let exercise: Exercise
    
    private let height: CGFloat = 46
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    Text(exercise.name)
                        .customFont(size: 20, color: .white)
                    Text("\(exercise.currentWeight.clean)lbs")
                        .customFont(size: 20, color: Color.accentColor)
                    Spacer(minLength: 0)
                }
                Spacer(minLength: 0)
                HStack(spacing: 4) {
                    Image("RecentIcon")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.white)
                        .offset(y: 1)
                    Text("Last Friday")
                        .customFont(size: 16, color: .white)
                }
                .opacity(0.2)

            }
            Spacer()
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient.accent)
                .frame(width: height)
                .overlay {
                    Image("PlayIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 16)
                        .foregroundColor(Color("CardBackground"))

                }
            
        }
        .frame(height: height)
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: -2)
        )
    }
}

#Preview {
    LiftItemView(exercise: Exercise(name: "Deadlift"))
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
