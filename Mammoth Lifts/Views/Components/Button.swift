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

struct AccentButtonStyle: ButtonStyle {
    var stretch: Bool = false
    
    private let height: CGFloat = 55
    
    
    static var backgroundColor: Color = .accentColor
    static var foregroundColor: Color = .background
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if stretch {
                Spacer()
            }
            configuration.label
                .customFont(
                    .button,
                    color: Self.foregroundColor
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
                .fill(Self.backgroundColor)
                .buttonPressModifier(isPressed: configuration.isPressed)
                .id("primarybutton")

        }
    }
}


struct SecondaryButtonStyle: ButtonStyle {
    var stretch: Bool = false
    
    private let height: CGFloat = 55
    
    
    static var backgroundColor: Color = Color(.secondaryButtonBackground)
    static var foregroundColor: Color = .white.opacity(0.8)
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if stretch {
                Spacer()
            }
            configuration.label
                .customFont(
                    .button,
                    color: Self.foregroundColor
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
                .fill(Self.backgroundColor)
                .buttonPressModifier(isPressed: configuration.isPressed)
                .id("secondarybutton")
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


extension ButtonStyle where Self == SecondaryButtonStyle {
    internal static var secondary: SecondaryButtonStyle { return SecondaryButtonStyle()}
}

extension ButtonStyle where Self == AccentButtonStyle {
    internal static var accent: AccentButtonStyle { return AccentButtonStyle()}
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
