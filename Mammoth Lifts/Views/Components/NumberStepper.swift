import SwiftUI


struct NumberStepper: View {
    @Binding var value: Int
    var bounds: ClosedRange<Int>
    
    @State var goingUp: Bool = true
    
    var isMin: Bool {
        value <= bounds.lowerBound
    }
    var isMax: Bool {
        value >= bounds.upperBound
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                value -= 1
            } label: {
                Text("-")
                    .offset(y: -1)
            }
            .disabled(isMin)
            .buttonStyle(NumberStepperButtonStyle())
            .buttonRepeatBehavior(.enabled)
            
            Rectangle()
                .fill(Color(.border))
                .frame(width: 1, height: 16)
            
            Text(String(value))
                .customFont(size: 20)
                .frame(width: 35)

            Rectangle()
                .fill(Color(.border))
                .frame(width: 1, height: 16)
            
            Button {
                value += 1
            } label: {
                Text("+")
            }
            .disabled(isMax)
            .buttonStyle(NumberStepperButtonStyle())
            .buttonRepeatBehavior(.enabled)


        }
        .sensoryFeedback(.selection, trigger: value)

        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        }
        .fixedSize(horizontal: true, vertical: false)
    }
    
    
    
    struct NumberStepperButtonStyle: ButtonStyle {
        @Environment(\.isEnabled) var isEnabled
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .customFont(size: 30, color: .accentColor)
                .opacity(isEnabled ? 1 : 0.2)
                .offset(y: -1)
                .animation(.spring(duration: 0.15), value: isEnabled)
                .padding(.horizontal, 10)
                .padding(.vertical, 1)
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
