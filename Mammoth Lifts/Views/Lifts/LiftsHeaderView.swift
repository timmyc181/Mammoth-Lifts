//
//  LiftsHeaderView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/13/23.
//

import SwiftUI

struct LiftsHeaderView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var name: String = ""
    @State private var showingAlert: Bool = false
    
    var body: some View {
        HStack {
            Text("Lifts")
                .customFont(.heading)
                .accentGradientForeground()
            Spacer()
            Button {
                showingAlert = true

            } label: {
                Image("PlusIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white.opacity(1))
                    .offset(y: 2)
            }

            .alert("Name", isPresented: $showingAlert) {
                TextField("Name", text: $name)
                Button("OK") {
                    let newLift = Exercise(name: name)
                    modelContext.insert(newLift)
                }
            } message: {
                Text("Xcode will print whatever you type.")
            }
        }

    }
}

#Preview {
    LiftsHeaderView()
}



extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing)
        )
            .mask(self)
    }
    
    public func accentGradientForeground() -> some View {
        self.gradientForeground(colors: [Color("AccentGradientStart"), Color("AccentGradientEnd")])
    }
}
