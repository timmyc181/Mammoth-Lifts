//
//  SelectedTabBarIndicatorView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/11/23.
//

import SwiftUI

struct SelectedTabBarIndicatorView: View {
    @Environment(\.navigation) private var navigation
    
    var body: some View {
        HStack(spacing: 0) {
            Group {
                if navigation.tab == .log {
                    Spacer()
                }
                
                Color.clear.frame(width: 0)
                
                Spacer()
                    .frame(height: 6)
                    .background {
                        Circle()
                            .fill(Color.accentColor)
                    }
                
                Color.clear.frame(width: 0)
                
                if navigation.tab == .lifts {
                    Spacer()
                }
            }
            .frame(height: 6)
        }
    }
}

#Preview {
    SelectedTabBarIndicatorView()
}
