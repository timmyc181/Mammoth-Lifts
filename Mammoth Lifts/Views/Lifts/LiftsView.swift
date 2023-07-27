//
//  LiftsView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/11/23.
//

import SwiftUI
import SwiftData

struct LiftsView: View {
//    @Query(sort: \.name, animation: .snappy)
//    private var exercises: [Exercise]

    var body: some View {
        VStack {
            LiftsHeaderView()
                .padding(.top, 10)
            
            VStack(spacing: 16) {
//                ForEach(exercises) { exercise in
//                    LiftItemView(exercise: exercise)
//                        .transition(.scale)
//                }
                Spacer()

            }

        }
        .padding(.horizontal, Constants.sidePadding)
    }
}

#Preview {
    LiftsView()
}



