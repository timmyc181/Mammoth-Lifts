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
            AddLiftHeaderTitleView()
                .opacity(0)
            
            Spacer(minLength: 20)
            
            ProgressBarView(progress: progress)
                .frame(maxWidth: 100)
                .offset(y: 2)
            
            Spacer(minLength: 20)
            
            AddLiftHeaderTitleView()
                .opacity(0)
                .overlay(alignment: .trailing) {
                    Button {
                        navigation.addLiftPresented = false
                    } label: {
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 28, height: 28)
                            .overlay {
                                Image("CloseIcon")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        
                            
                    }
                }
        }
    }
}


fileprivate struct AddLiftHeaderTitleView: View {
    var body: some View {
        Text("New lift")
            .customFont()
    }
}

#Preview {
    AddLiftView()
        .environment(Navigation())
//        .padding(.horizontal, Constants.sheetPadding)
        .background {
            Color.sheetBackground
                .ignoresSafeArea()
        }
}
