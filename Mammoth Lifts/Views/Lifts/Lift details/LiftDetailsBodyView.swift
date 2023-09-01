//

import SwiftUI

struct LiftDetailsBodyView: View {
    @Bindable var liftDetailsState: LiftDetailsState
    
    var restTimeText: String {
        let minutes = liftDetailsState.lift.restTimeMinutes
        let seconds = liftDetailsState.lift.restTimeSeconds
        
        if seconds == 0 {
            return String(minutes) + " min"
        }
        
        return String(minutes) + "m " + String(seconds) + "s"
    }
    
    var body: some View {
        ListView {
            ListItemView(sidePadding: false) {
                ItemView(title: "Weight", action: editWeight) {
                    Text(liftDetailsState.lift.currentWeight.clean)
                    + Text(" lb")
                }
                ItemView(title: "Increment", action: editIncrement) {
                    Text(liftDetailsState.lift.increment.clean)
                    + Text(" lb")
                }
            }
            .background(rectangleSpacer)
            ListItemView(divider: false, sidePadding: false) {
                ItemView(title: "Sets") {
                    NumberStepper(value: $liftDetailsState.lift.targetSets, bounds: Constants.setsRange)
                }
                ItemView(title: "Reps") {
                    NumberStepper(value: $liftDetailsState.lift.targetReps, bounds: Constants.repsRange)
                }
            }
            .background(rectangleSpacer)
        }
        
        
        ListView {
            ListItemView(divider: false) {
                Text("Rest time")
                Spacer()
                Button {
                } label: {
                    Text(restTimeText)
                }
                .buttonStyle(DateTimeSelectorButtonStyle())
//                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
//                    .colorScheme(.dark)
            }
        }
        
        Spacer()
        
        Button {
            
        } label: {
            Text("Delete lift")
        }
        .buttonStyle(SecondaryAccentButtonStyle(stretch: true, color: Color(.trash)))
    }
    
    private func editWeight() {
        liftDetailsState.focusState = .weight
    }
    
    private func editIncrement() {
        liftDetailsState.focusState = .increment
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



//#Preview {
//    LiftDetailsBodyView()
//}




