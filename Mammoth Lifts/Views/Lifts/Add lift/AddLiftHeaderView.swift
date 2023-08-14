//
//  AddLiftHeaderView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/16/23.
//

import SwiftUI

struct AddLiftHeaderView: View {
    var progress: Double
    
    @Environment(\.navigation) private var navigation
    
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
                    CloseSheetButton {
                        navigation.addLiftPresented = false
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
    AddLiftPreviewView()

}
