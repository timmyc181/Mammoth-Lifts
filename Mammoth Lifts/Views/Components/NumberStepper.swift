import SwiftUI


struct NumberStepper: View {
    @Binding var value: Int
    var bounds: ClosedRange<Int>
    
    @State var animationValue: Int = 0
    @State var goingUp: Bool = true
    
    var isMin: Bool {
        value <= bounds.lowerBound
    }
    var isMax: Bool {
        value >= bounds.upperBound
    }
    
    
    
    init(value: Binding<Int>, bounds: ClosedRange<Int>) {
        self._value = value
        self.bounds = bounds
        self.animationValue = value.wrappedValue
        self.goingUp = goingUp
    }
    
    var body: some View {
        HStack(spacing: 3) {
            Button {
                value -= 1
            } label: {
                Text("-")
                    .padding(20)
                    .offset(y: -1)
            }
            .padding(-20)
            .disabled(isMin)
            .buttonStyle(NumberStepperButtonStyle())

            Text(String(value))
                .foregroundColor(.accentColor)
                .customFont(size: 20)
                .frame(width: 35)
//                .transition(.stepperText(goingUp: goingUp))
//                .id("number\(animationValue)")
            
            Button {
                value += 1
            } label: {
                Text("+")
                    .padding(20)
            }
            .padding(-20)
            .disabled(isMax)
            .buttonStyle(NumberStepperButtonStyle())


        }
        .sensoryFeedback(.selection, trigger: value)
//        .animation(.snappy(duration: 0.15), value: animationValue)
        .customFont(size: 24)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)

        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.1))
        }
//        .onAppear {
//            animationValue = value
//        }
//        .onChange(of: value) { oldValue, newValue in
//            goingUp = oldValue < newValue
//            
//            animationValue = value
//        }
        
    }
    
    
    
    struct NumberStepperButtonStyle: ButtonStyle {
        @Environment(\.isEnabled) var isEnabled
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(isEnabled ? .white : .white.opacity(0.2))
                .animation(.spring(duration: 0.15), value: isEnabled)
                .contentShape(Rectangle())
        }
    }
}



extension AnyTransition {
    static func stepperText(goingUp: Bool) -> AnyTransition {
        AnyTransition
            .asymmetric(
                insertion: .modifier(active: StepperPushTransition(value: 0, moveUp: goingUp), identity: StepperPushTransition(value: 1, moveUp: goingUp)),
                removal: .modifier(active: StepperPushTransition(value: 0, moveUp: !goingUp), identity: StepperPushTransition(value: 1, moveUp: !goingUp))
            )

        
    }
}

struct StepperPushTransition: ViewModifier {
    var value: Double
    var moveUp: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(x: 10 * (1 - value) * (moveUp ? 1 : -1))
            .opacity(value*2)
    }
}


#Preview {
    ZStack {
        Color.background.ignoresSafeArea()
        NumberStepper(value: .constant(5), bounds: 0...10)

    }
}
