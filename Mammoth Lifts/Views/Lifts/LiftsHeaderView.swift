//
//  LiftsHeaderView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/13/23.
//

import SwiftUI

struct LiftsHeaderView: View {
    @Environment(Navigation.self) private var navigation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    navigation.addLiftPresented = true
                } label: {
                    Image("PlusIcon")
                        .resizable()
                        .frame(width: 19, height: 19)
                        .accentGradientForeground()
                }
            }
            HStack {
                Text("Lifts")
                    .customFont(.heading)
                Spacer()

            }
        }
        

    }
}

#Preview {
    LiftsHeaderView()
}



extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing)
        )
            .mask(self)
    }
    
    public func accentGradientForeground() -> some View {
        self.gradientForeground(colors: [Color("AccentGradientStart"), Color("AccentGradientEnd")])
//        self.gradientForeground(colors: [Color.blue, Color("AccentGradientEnd")])
    }
    
}


extension LinearGradient {
    public static var accentGradient = LinearGradient(
        colors: [Color("AccentGradientStart"), Color("AccentGradientEnd")],
        startPoint: .leading,
        endPoint: .trailing)
}
