//
//  TabBarView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/11/23.
//

import SwiftUI

struct TabBarView: View {
    @Environment(Navigation.self) var navigation
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 5) {
                HStack {
                    TabBarItemView(navigateTo: .lifts, iconName: "LiftsIcon")
                    TabBarItemView(navigateTo: .log, iconName: "LogIcon")

                }
                SelectedTabBarIndicatorView()
                
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            .padding(.top, 30)
            .background(
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(LinearGradient(colors: [Color.background.opacity(0), Color.background], startPoint: .top, endPoint: .bottom))
                        .frame(height: 80)
                    Rectangle()
                        .fill(Color.background)
                        .ignoresSafeArea()
                    
                }
                    .opacity(0.9)

            )

        }
        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
    }
}


#Preview {
    TabBarView()
        .environment(Navigation())
}
