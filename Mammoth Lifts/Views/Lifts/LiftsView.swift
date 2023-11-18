//
//  LiftsView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/11/23.
//

import SwiftUI
import SwiftData

struct LiftsView: View {
    @Environment(\.navigation) private var navigation
    
    @Query(animation: .bouncy)
    var lifts: [Lift]

    var body: some View {
        @Bindable var navigation = navigation
        VStack {
            LiftsHeaderView()
                .padding(.top, 15)
            
            if lifts.count > 0 {
                VStack(spacing: 16) {
                    ForEach(lifts) { lift in
                        LiftItemView(lift: lift)
                            .transition(.scale(0.9).combined(with: .opacity))
                    }
                    Spacer()
                    
                }
            } else {
                EmptyLiftsView()
                
            }
            

        }
        .padding(.horizontal, Constants.sidePadding)
    }
}

#Preview {
    ContentView()
        .emptyPreviewContainer()
}



