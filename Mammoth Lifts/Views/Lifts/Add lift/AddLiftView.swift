//
//  AddLiftView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/15/23.
//

import SwiftUI

struct AddLiftView: View {
    @State var addLiftState = AddLiftState()
    
    var body: some View {
        VStack {
            AddLiftHeaderView(progress: addLiftState.progress)
                .padding(.top, 20)
            Spacer()
            switch addLiftState.state {
            case .lift:
                Text("Lift")
                    .customFont()
            case .weight:
                Text("Weight")
                    .customFont()
            case .setsReps:
                Text("Sets reps")
                    .customFont()
            case .rest:
                Text("Rest")
                    .customFont()
            case .increment:
                Text("Increment")
                    .customFont()
            }
            Spacer()
            HStack {
                RegularButton(type: .secondary, stretch: false) {
                    addLiftState.previous()
                } label: {
                    Image("ChevronIcon")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .scaleEffect(x: -1)
                        .offset(x: -2)
                }
                Spacer()
                RegularButton(type: .accent, stretch: false) {
                    addLiftState.next()
                } label: {
                    Text("Next")
                        .padding(.horizontal, 25)
                        .offset(y: -1)
                }

            }
            .padding(.bottom, 30)
        }
    }
}





@Observable class AddLiftState {
    var state: State = .lift
    
    var progress: Double {
        Double(state.rawValue) / 6
    }
    
    enum State: Int {
        case lift = 1
        case weight = 2
        case setsReps = 3
        case rest = 4
        case increment = 5
    }
    
    
    func next() {
        state = State(rawValue: state.rawValue + 1) ?? .lift
    }
    
    func previous() {
        state = State(rawValue: state.rawValue - 1) ?? .lift
    }
    
}
