//
//  LiftsView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/11/23.
//

import SwiftUI
import SwiftData

struct LiftsView: View {
    @Query(animation: .bouncy)
    var lifts: [Lift]

    var body: some View {
        VStack {
            LiftsHeaderView()
                .padding(.top, 15)
            
            VStack(spacing: 16) {
                ForEach(lifts) { lift in
                    LiftItemView(exercise: lift)
                        .transition(.scale(0.9).combined(with: .opacity))
                }
                Spacer()

            }

        }
        .padding(.horizontal, Constants.sidePadding)
    }
}

#Preview {
    ContentView()
}



