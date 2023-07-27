//
//  ProgressBarView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/16/23.
//

import SwiftUI

struct ProgressBarView: View {
    var progress: Double
    
    private let height: CGFloat = 8
    
    var body: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(Color.white.opacity(0.05))
            .frame(height: height)
            .overlay {
                GeometryReader { geo in
                    Rectangle()
                        .fill(LinearGradient.accentGradient)
//                        .accentGradientForeground()
                        .mask(alignment: .leading) {
                            
                            RoundedRectangle(cornerRadius: height / 2)
                                .frame(width: geo.size.width * progress)
                        }
                }
                
            }
            .animation(.smooth, value: progress)
    }
}
