//
//  TabBarItemView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/11/23.
//

import SwiftUI

struct TabBarItemView: View {
    @Environment(\.navigation) private var navigation

    var navigateTo: Tab
    var iconName: String
    
    var body: some View {

        Button {
            navigation.tab = navigateTo
        } label: {
            Image(iconName)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white.opacity(navigation.tab == navigateTo ? 1 : 0.15))
        }
        .buttonStyle(TabBarButtonStyle())
    }
}


struct TabBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.85 : 1)
                .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            Spacer()
        }
        .padding(.top, 15)
//        .padding(.bottom, 5)
        .contentShape(Rectangle())
    }
}
