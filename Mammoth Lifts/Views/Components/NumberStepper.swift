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
        HStack(spacing: 0) {
            Button {
                value -= 1
            } label: {
                Text("-")
                    .padding(5)
                    .offset(y: -1)
            }
            .padding(-5)
            .padding(.horizontal, 8)
            .disabled(isMin)
            .buttonStyle(NumberStepperButtonStyle())
            .buttonRepeatBehavior(.enabled)
            
            Rectangle()
                .fill(Color(.border))
                .frame(width: 1, height: 16)
            
            Text(String(value))
                .customFont(.list)
                .frame(width: 30)

            Rectangle()
                .fill(Color(.border))
                .frame(width: 1, height: 16)
            
            Button {
                value += 1
            } label: {
                Text("+")
                    .padding(5)
            }
            .padding(-5)
            .padding(.horizontal, 8)
            .disabled(isMax)
            .buttonStyle(NumberStepperButtonStyle())
            .buttonRepeatBehavior(.enabled)


        }
        .sensoryFeedback(.selection, trigger: value)
        .customFont(size: 22)
        .padding(.vertical, 2)

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
                .foregroundColor(isEnabled ? .accentColor : .accentColor.opacity(0.2))
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
        NumberStepper(value: .constant(5), bounds: Constants.repsRange)

    }
}
