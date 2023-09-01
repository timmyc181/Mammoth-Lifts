import SwiftUI

struct LogWorkoutFormView: View {
    @Bindable var logWorkoutState: LogWorkoutState
    
    @State private var decimalActive: Bool? = nil

    private var weightComponents: Binding<WeightKeyboard.WeightComponents> {
        Binding {
//            weightComponents.wrappedValue
            WeightKeyboard.WeightComponents(weight: logWorkoutState.weight, decimalActive: decimalActive)
        } set: { components in
            logWorkoutState.weight = components.getWeight()
            decimalActive = components.decimalActive
        }

    }
    
    
    var body: some View {
        VStack(spacing: 15) {
            
            WeightKeyboardWeightView(weight: $logWorkoutState.weight, weightComponents: weightComponents.wrappedValue, increment: logWorkoutState.lift.increment)
            LogWorkoutDateView(date: $logWorkoutState.date)
        }
        
    }
}

#Preview {
    DumbPreviewThing {
        LogWorkoutFormView(logWorkoutState: LogWorkoutState(lift: .template(for: .bench)))

    }
    .modelContainer(for: [Lift.self, Workout.self, Set.self], inMemory: true)
    
}

struct DumbPreviewThing<Content: View>: View {
    var previewMode: PreviewMode = .sheet
    @ViewBuilder var content: () -> Content
    
    @State private var appear = false
    
    var body: some View {
        ZStack {
            Color(previewMode == .normal ? .background : .sheetBackground).ignoresSafeArea()
                .onAppear {
                    appear = true
                }
            if appear {
                content()
                    .padding(previewMode == .normal ? Constants.sidePadding : Constants.sheetPadding)
            }
        }
        .modelContainer(for: [Lift.self, Workout.self, Set.self], inMemory: true)

    }
    
    enum PreviewMode {
        case normal, sheet
    }
}

