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




struct ButtonStyleView: View {
    var configuration: ButtonStyle.Configuration
    var foregroundColor: Color
    var backgroundColor: Color
    var stretch: Bool = false
    
    static let height: CGFloat = 55

    
    var body: some View {
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
        .frame(height: Self.height)
        .frame(minWidth: Self.height)
        .background {
            RoundedRectangle(cornerRadius: Self.height / 2)
                .fill(backgroundColor)
                .buttonPressModifier(isPressed: configuration.isPressed)
//                .id("primarybutton")

        }
    }
}



struct AccentButtonStyle: ButtonStyle {
    var stretch: Bool = false
    
    var foregroundColor: Color = Self.foregroundColor
    var backgroundColor: Color = Self.backgroundColor
    
    static var foregroundColor: Color = .background
    static var backgroundColor: Color = .accentColor

    func makeBody(configuration: Configuration) -> some View {
        ButtonStyleView(
            configuration: configuration,
            foregroundColor: Self.foregroundColor,
            backgroundColor: Self.backgroundColor,
            stretch: stretch
        )
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    var stretch: Bool = false

    var foregroundColor: Color = Self.foregroundColor
    var backgroundColor: Color = Self.backgroundColor
    
    static var foregroundColor: Color = .white.opacity(0.8)
    static var backgroundColor: Color = Color(.secondaryButtonBackground)

    
    func makeBody(configuration: Configuration) -> some View {
        ButtonStyleView(
            configuration: configuration,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stretch: stretch
        )
    }
}

struct SecondaryAccentButtonStyle: ButtonStyle {
    var stretch: Bool = false
    
    var color: Color = Self.foregroundColor
    
    static var foregroundColor: Color = .accentColor
    static var backgroundColor: Color = .accentColor.opacity(0.1)

    func makeBody(configuration: Configuration) -> some View {
        ButtonStyleView(
            configuration: configuration,
            foregroundColor: color,
            backgroundColor: color.opacity(0.1),
            stretch: stretch
        )
    }
}

struct GenericButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1)
            .animation(.snappy, value: configuration.isPressed)
    }
}



extension ButtonStyle where Self == AccentButtonStyle {
    
    internal static var accent: AccentButtonStyle {
        return AccentButtonStyle(stretch: false)
    }
    internal static var accentStretch: AccentButtonStyle {
        return AccentButtonStyle(stretch: true)
    }
}


extension ButtonStyle where Self == SecondaryButtonStyle {

    internal static var secondary: SecondaryButtonStyle {
        return SecondaryButtonStyle(stretch: false)
    }
    internal static var secondaryStretch: SecondaryButtonStyle {
        return SecondaryButtonStyle(stretch: true)
    }
}

extension ButtonStyle where Self == SecondaryAccentButtonStyle {

    internal static var secondaryAccent: SecondaryAccentButtonStyle {
        return SecondaryAccentButtonStyle(stretch: false)
    }
    internal static var secondaryAccentStretch: SecondaryAccentButtonStyle {
        return SecondaryAccentButtonStyle(stretch: true)
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
