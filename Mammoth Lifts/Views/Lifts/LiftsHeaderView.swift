//
//  LiftsHeaderView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/13/23.
//

import SwiftUI

struct LiftsHeaderView: View {
    @Environment(\.navigation) private var navigation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    navigation.addLiftPresented = true
                } label: {
//                        Color.background
//                            .frame(width: 60, height: 60)
//                            .padding(50)

//                        Image("PlusIcon")
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .heavy))
//                            .resizable()
//                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.accentColor)
                            .padding(10)
                            .contentShape(Rectangle())
                }
                .padding(-10)
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
    ContentView()
}



//extension View {
//    public func gradientForeground(colors: [Color]) -> some View {
//        self.overlay(
//            LinearGradient(
//                colors: colors,
//                startPoint: .leading,
//                endPoint: .trailing)
//        )
//            .mask(self)
//    }
//    
//    public func accentGradientForeground() -> some View {
//        self.gradientForeground(colors: [Color("AccentGradientStart"), Color("AccentGradientEnd")])
//    }
//    
//}


extension LinearGradient {
//    public static var g = Color.accentColor.
    
    public static var accentGradient = LinearGradient(
        colors: [Color("AccentColor"), Color("AccentColor").shiftHue(by: -0.03)],
        startPoint: .leading,
        endPoint: .trailing
    )
}


extension Color {
    func shiftHue(by hue: CGFloat) -> Color {
        var color = UIColor(self)
        var currentHue: CGFloat = 0
        var currentSaturation: CGFloat = 0
        var currentBrigthness: CGFloat = 0
        var currentOpacity: CGFloat = 0

        if color.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentOpacity) {

            return Color(hue: currentHue + hue, saturation: currentSaturation, brightness: currentBrigthness, opacity: currentOpacity)

        }
        return self
    }
}
