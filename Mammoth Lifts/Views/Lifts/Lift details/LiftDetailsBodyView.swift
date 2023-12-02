//

import SwiftUI

struct LiftDetailsBodyView: View {
    @Bindable var lift: Lift
    
    @Environment(\.navigation) private var navigation
    
    @State private var editWeightPresented: Bool = false
    @State private var editIncrementPresented: Bool = false
    
    var restTimeText: String {
        let minutes = lift.restTimeMinutes
        let seconds = lift.restTimeSeconds
        
        if seconds == 0 {
            return String(minutes) + " min"
        }
        
        return String(minutes) + "m " + String(seconds) + "s"
    }
    
    var body: some View {
        ListView {
            ListItemView(sidePadding: false) {
                ItemView(title: "Weight", action: editWeight) {
                    Text(lift.currentWeight.text)
                    + Text(" lb")
                }
                .editWeight($lift.currentWeight, increment: lift.increment, isPresented: $editWeightPresented)
                
                ItemView(title: "Increment", action: editIncrement) {
                    Text(lift.increment.text)
                    + Text(" lb")
                }
                .editWeight($lift.increment, increment: 0.25, isPresented: $editIncrementPresented)
            }
            .background(rectangleSpacer)
            ListItemView(divider: false, sidePadding: false) {
                ItemView(title: "Sets") {
//                    Thing2(value: lift.targetSets)
                    NumberStepper(value: $lift.targetSets, bounds: Constants.setsRange)
                }
                ItemView(title: "Reps") {
                    NumberStepper(value: $lift.targetReps, bounds: Constants.repsRange)
                }
            }
            .background(rectangleSpacer)
        }
        
        
        ListView {
            ListItemView(divider: false) {
                Text("Rest time")
                Spacer()
                
                DurationPickerView(minute: $lift.restTimeMinutes, second: $lift.restTimeSeconds)
                    .durationPickerType(.compact)
                
//                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
//                    .colorScheme(.dark)
            }
        }
        
        Spacer()
        
        Button {
            navigation.liftToDelete = lift
        } label: {
            Text("Delete lift")
        }
        .buttonStyle(SecondaryAccentButtonStyle(stretch: true, color: Color(.error)))
    }
    
    private func editWeight() {
        editWeightPresented = true
    }
    
    private func editIncrement() {
        editIncrementPresented = true
    }
    
    @ViewBuilder private var rectangleSpacer: some View {
        Rectangle()
            .fill(Color(.border))
            .frame(width: 1)
            .padding(.vertical)
    }
    
    
    struct ItemView<Content: View>: View {
        var title: String
        var action: (() -> ())? = nil
        @ViewBuilder var innerContent: Content
        
        
        @ViewBuilder var content: some View {
            HStack {
                Spacer()
                VStack {
                    Text(title)
                        .customFont(size: 14, color: .white.opacity(0.3))
                    
                    innerContent
                        .customFont(size: 20)
                }
                Spacer()
            }
            
//            .frame(maxWidth: .infinity)
            
        }
        
        
        var body: some View {
            if let action = action {
                Button {
                    action()
                } label: {
                    content
                        .contentShape(Rectangle())
                }
                .buttonStyle(.generic)

            } else {
                content
            }
        }
    }
}

struct Thing2: View {
    var value: Int
    
    var body: some View {
        Text(String(value))
    }
}



//#Preview {
//    LiftDetailsBodyView()
//}




