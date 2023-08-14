//
//  Button.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/16/23.
//

import SwiftUI

struct CommonButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(ButtonPressModifier(isPressed: configuration.isPressed))
    }
}




struct FilledButtonStyle: ButtonStyle {
    var stretch: Bool = false
    var foregroundColor: Color
    var backgroundColor: Color
    
    private let height: CGFloat = 55
    
    
    static var accentBackgroundColor: Color = .accentColor
    static var accentForegroundColor: Color = .background
    
    static var secondaryBackgroundColor: Color = Color(.secondaryButtonBackground)
    static var secondaryForegroundColor: Color = .white.opacity(0.8)

    
    
    
    
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if stretch {
                Spacer()
            }
            configuration.label
                .customFont(
                    .button,
                    color: foregroundColor
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
                .fill(backgroundColor)
                .buttonPressModifier(isPressed: configuration.isPressed)
                .id("primarybutton")

        }
    }
}



struct GenericButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1)
            .animation(.snappy, value: configuration.isPressed)
    }
}



extension ButtonStyle where Self == FilledButtonStyle {
    
    internal static var secondary: FilledButtonStyle {
        return FilledButtonStyle(
            foregroundColor: FilledButtonStyle.secondaryForegroundColor,
            backgroundColor: FilledButtonStyle.secondaryBackgroundColor
        )
    }
}


extension ButtonStyle where Self == FilledButtonStyle {

    internal static var accent: FilledButtonStyle {
        return FilledButtonStyle(
            foregroundColor: FilledButtonStyle.accentForegroundColor,
            backgroundColor: FilledButtonStyle.accentBackgroundColor
        )
    }
}


extension ButtonStyle where Self == GenericButtonStyle {
    internal static var generic: GenericButtonStyle { return GenericButtonStyle()}
}



extension View {
    func buttonPressModifier(isPressed: Bool) -> some View {
        modifier(ButtonPressModifier(isPressed: isPressed))
    }
    
    func expandTouchArea(by amount: CGFloat = 10) -> some View {
        modifier(ExpandTouchAreaModifier(amount: amount))
    }
}


fileprivate struct ButtonPressModifier: ViewModifier {
    var isPressed: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(isPressed ? 0.6 : 1)
            .animation(.snappy, value: isPressed)
    }
}


fileprivate struct ExpandTouchAreaModifier: ViewModifier {
    var amount: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(amount)
            .contentShape(Rectangle())
            .padding(-amount)
    }
}
