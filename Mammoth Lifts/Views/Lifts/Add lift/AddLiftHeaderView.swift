//
//  AddLiftHeaderView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/16/23.
//

import SwiftUI

struct AddLiftHeaderView: View {
    var progress: Double
    
    @Environment(Navigation.self) var navigation
    
    let iconWidth: CGFloat = 28
    
    var body: some View {
        HStack {
            Color.clear
                .frame(width: iconWidth, height: 0)
            Spacer()
            ProgressBarView(progress: progress)
                .frame(width: 125)
            
            Spacer()
            
            Button {
                navigation.addLiftPresented = false
            } label: {
                Image("CloseIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white.opacity(0.6))
                    
            }
            .frame(width: iconWidth)

        }
    }
}
