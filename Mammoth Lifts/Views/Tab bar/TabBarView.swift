//
//  TabBarView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/11/23.
//

import SwiftUI

struct TabBarView: View {
    @Environment(\.navigation) private var navigation
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                TabBarItemView(navigateTo: .lifts, iconName: "LiftsIcon")
                TabBarItemView(navigateTo: .log, iconName: "LogIcon")

            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            .padding(.top, 30)
            .background(
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(LinearGradient(colors: [Color.background.opacity(0), Color.background], startPoint: .top, endPoint: .bottom))
                        .frame(height: Constants.tabBarSafeArea)
                    Rectangle()
                        .fill(Color.background)
                        .ignoresSafeArea()
                    
                }
                    .opacity(0.9)

            )
            .animation(.smooth(duration: 0.3), value: navigation.tab)

        }
        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
    }
}


#Preview {
    TabBarView()
}
