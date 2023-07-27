//
//  ChooseWeightTextView.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/18/23.
//

import SwiftUI

struct ChooseWeightTextView: View {
    @Environment(AddLiftState.self) var addLiftState
    
    @State var goingUp: Bool = true

    var weightDigits: [String] {
        
        let weight = (addLiftState.exercise?.currentWeight ?? 1010).clean
        return weight.components(separatedBy: ".")
    }
    
    var wholeDigits: [Int] {
        return weightDigits[0].compactMap{ $0.wholeNumberValue }
    }
    
    var decimalDigits: [Int] {
        if weightDigits.count == 2 {
            return weightDigits[1].compactMap{ $0.wholeNumberValue }
        }
        return []
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<wholeDigits.count, id: \.self) { index in
                    let weightDigit = wholeDigits[index]
                        Text(String(weightDigit))
                        .transition(.weightText(goingUp: goingUp))
                        .id("text\(index)\(weightDigit)")

                }


                
                let firstDecimal = decimalDigits.count > 0 ? String(decimalDigits[0]) : "0"
                let secondDecimal = decimalDigits.count > 1 ? String(decimalDigits[1]) : "0"
                
                Group {
                    Text(".")
                        .foregroundColor(decimalDigits.count > 0 ? .white : .white.opacity(0.2))
                        .padding(.leading, 3)
                    
                    Text("0")
                        .opacity(0)
                        .overlay {
                            Text(firstDecimal)
                                .foregroundColor(firstDecimal == "0" ? .white.opacity(0.2) : .white)
                        }
                        .transition(.weightText(goingUp: goingUp, small: true))

                        .id("text\(index)\(firstDecimal)")

                    Text("0")
                        .opacity(0)
                        .overlay {
                            Text(secondDecimal)
                                .foregroundColor(secondDecimal == "0" ? .white.opacity(0.2) : .white)
                        }
                        .transition(.weightText(goingUp: goingUp, small: true))
                        .id("text\(index)\(secondDecimal)")
                }
                .customFont(size: 25)
                .padding(.top, 13)
                



            }
            .customFont(size: 60)



            Text("pounds")
                .customFont(color: .white.opacity(0.2))
                .padding(.top, -5)
                .padding(.bottom, 20)
        }
        .animation(.easeInOut.speed(5), value: addLiftState.exercise?.currentWeight)
        .onChange(of: addLiftState.exercise?.currentWeight) { oldValue, newValue in
            if let oldValue = oldValue,
               let newValue = newValue {
                if newValue > oldValue {
                    goingUp = true
                } else {
                    goingUp = false
                }
            }
        }

    }
}

#Preview {
    ZStack {
        Color.sheetBackground
            .ignoresSafeArea()
        ChooseWeightView()
            .environment(Navigation())
            .environment(AddLiftState())
    }
}


extension AnyTransition {
    static func weightText(goingUp: Bool, small: Bool = false) -> AnyTransition {
        AnyTransition
            .asymmetric(
                insertion: .modifier(active: PushTransition(value: 0, moveUp: goingUp, small: small), identity: PushTransition(value: 1, moveUp: goingUp, small: small)),
                removal: .modifier(active: PushTransition(value: 0, moveUp: !goingUp, small: small), identity: PushTransition(value: 1, moveUp: !goingUp, small: small))
            )

        
    }
}

struct PushTransition: ViewModifier {
    var value: Double
    var moveUp: Bool
    var small: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(y: (small ? 5 : 10) * (1 - value) * (moveUp ? 1 : -1))
            .opacity(value)
    }
}
