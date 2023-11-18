import SwiftUI


struct LogWorkoutView: View {
    @Environment(\.navigation) private var navigation
    @Environment(\.modelContext) private var modelContext
    
    var lift: Lift
    
    @State private var weight: Weight
    
    @State private var weightText: String
    @State private var date = Date()
    
    @State private var haptic = UUID()

    
    init(lift: Lift) {
        self.lift = lift
        self._weight = State(initialValue: lift.currentWeight)
        self._weightText = State(initialValue: String(lift.currentWeight))
    }
    
    
    static let expandedSheetHeight: CGFloat = 300
    static let finalBottomPadding: CGFloat = 40

    @State private var extraSheetHeight: CGFloat = 0
    
    private var keyboardExpandedAmount: CGFloat {
        extraSheetHeight / Self.expandedSheetHeight
    }
    
    private var bottomPadding: CGFloat {
        keyboardExpandedAmount * Self.finalBottomPadding
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            WeightKeyboardWeightView(weight: $weight, weightText: weightText, increment: lift.increment, onTap: toggleSheet)
                .padding(.bottom, 15)


            VStack(spacing: 40) {
                LogWorkoutDateView(date: $date)//0.8 + 0.2 * (1.0 - keyboardExpandedAmount))
//                    .padding(.bottom, bottomPadding / 2)
                LogWorkoutFooterView(log: log)
//                    .padding(.bottom, bottomPadding / 2)
            }
            
            ZStack(alignment: .top) {
                Color.black.opacity(0.3)
                    .padding(.top, 40)
                    .padding(.bottom, -40)
                LogWorkoutKeyboardView(height: 300, weight: $weight, weightText: $weightText)
                    .padding(.top, 50)
//                    .ignoresSafeArea(edges: .horizontal)

//                    .background {
//                        
//                    }

                    .frame(height: 300)
            }
            .frame(height: extraSheetHeight, alignment: .top)
//            .border(Color.blue)
            .ignoresSafeArea(edges: .horizontal)
            .ignoresSafeArea(edges: .bottom)
//            .border(Color.red)

        }
        .sheetDetents([Self.expandedSheetHeight], offset: $extraSheetHeight)
        .ignoresSafeArea(edges: .bottom)
        .sensoryFeedback(.success, trigger: haptic)


    }
    
    func toggleSheet() {
        withAnimation(Constants.sheetPresentationAnimation) {
            if extraSheetHeight == 0 {
                extraSheetHeight = Self.expandedSheetHeight
            } else {
                extraSheetHeight = 0
            }
        }

    }
    
    func log() {
        // Trigger haptic feedback
        haptic = UUID()
        
        let workout = Workout.getLoggedWorkout(weight: weight, date: date, lift: lift)
        
        modelContext.insert(workout)
        
        lift.workouts.append(workout)
        
        lift.updateWeight()


        navigation.logWorkoutPresented = false
        
    }

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


//#Preview {
//    LogWorkoutView()
//}
