//
//  Button.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/16/23.
//

import SwiftUI

struct RegularButton<Content: View>: View {
    var type: ButtonType = .accent
    var stretch: Bool = true
    
    var action: () -> Void
    @ViewBuilder var label: () -> Content
    
    var body: some View {
        Button(action: action, label: label)
            .buttonStyle(RegularButtonStyle(type: type, stretch: stretch))
    }
    

}

enum ButtonType {
    case accent, secondary
}

struct RegularButtonStyle: ButtonStyle {
    var type: ButtonType
    var stretch: Bool
    
    let height: CGFloat = 55
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if stretch {
                Spacer()
            }
            configuration.label
                .customFont(
                    .button,
                    color: type == .accent ? .background : .white.opacity(0.8)
                )
                .padding(.horizontal, 10)
            if stretch {
                Spacer()
            }
        }
        .frame(height: height)
        .frame(minWidth: height)
        .background {
            RoundedRectangle(cornerRadius: height / 2)
                .fill(
                    type == .accent ? Color.accentColor : Color.white.opacity(0.05)
                )
        }
    }
}
