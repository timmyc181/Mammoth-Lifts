//
//  LogView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/11/23.
//

import SwiftUI
import SwiftData

struct LogView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(animation: .snappy) private var workouts: [Workout]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(workouts) { workout in
                        HStack {
                            Text(workout.lift!.name)
                            Spacer()
                            Text(workout.date!.formatted())
                            
                        }
                    }
                    .customFont()
                }
            }
            .safeAreaPadding(.horizontal, Constants.sidePadding)
            
            Button {
                do {
                    try modelContext.delete(model: Workout.self)
                } catch {
                    fatalError("Couldn't delete entities in Workout model")
                }
            } label: {
                Text("Clear")
                    .padding(.horizontal)
            }
            .buttonStyle(.accent)
        }
        .safeAreaPadding(.bottom, Constants.tabBarSafeArea)
        
        
        
    }
}

#Preview {
    LogView()
}
