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
    
    @Query(sort: \Workout.date, order: .reverse, animation: .snappy) private var workouts: [Workout]
    
    var body: some View {
        VStack {
            List {
                ForEach(workouts) { workout in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(workout.lift?.name ?? "Error")
                            Group {
                                if workout.sets.count > 0 {
                                    Text("\(workout.sets[0].weight.text) lb")
                                } else {
                                    Text("Weight error")
                                }

                            }
                            .customFont(size: 14, color: Color(.secondaryText))

                            
                        }
                        Spacer()
                        Text(workout.date.relativeDateString.firstCapitalized)
                            .customFont(size: 14, color: Color(.secondaryText))
                        
                        
                    }
                    .customFont()
                }
                .onDelete(perform: { indexSet in
                    indexSet.forEach { i in
                        modelContext.delete(workouts[i])
                    }
                })
                
                
                
            }
//            ScrollView {
//                VStack {
//                    ForEach(workouts) { workout in
//                        
//                    }
//                    .customFont()
//                }
//            }
            .safeAreaPadding(.horizontal, Constants.sidePadding)
            
//            Button {
//                do {
//                    try modelContext.delete(model: Workout.self)
//                } catch {
//                    fatalError("Couldn't delete entities in Workout model")
//                }
//            } label: {
//                Text("Clear")
//                    .padding(.horizontal)
//            }
//            .buttonStyle(.accent)
        }
        .safeAreaPadding(.bottom, Constants.tabBarSafeArea)
        
        
        
    }
}

#Preview {
    LogView()
}
