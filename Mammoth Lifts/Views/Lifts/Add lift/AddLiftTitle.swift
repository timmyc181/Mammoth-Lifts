//
//  AddLiftDirections.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/18/23.
//

import SwiftUI

struct AddLiftTitle: View {
    var state: AddLiftState.State
    
    var body: some View {
        Group {
            switch state {
            case .lift:
                Text("New lift")
            case .weight:
                Text("Starting weight")
            case .setsReps:
                Text("Sets and reps")
            case .rest:
                Text("Rest between sets")
            case .increment:
                Text("Increment")


            }
        }
        .customFont(size: 30)
        .frame(maxWidth: .infinity)
    }
}


@Observable class Book {
    var text: String = "Timothy"
}

#Preview {
    AddLiftPreviewView()

}
