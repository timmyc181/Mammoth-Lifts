import SwiftUI


struct WeightKeyboardWeightView: View {
    @Binding var weight: Weight
    var weightText: String
    var increment: Weight
    var onTap: (() -> ())? = nil
    
    private let transition: AnyTransition = .scale(scale: 0.5, anchor: .init(x: 0.5, y: 0.75)).combined(with: .opacity)
    private let animation: Animation = .spring(duration: 0.25, bounce: 0, blendDuration: 0)
    
    var body: some View {
//        let _ = Self._printChanges()
        Button {
            onTap?()
        } label: {
            HStack(spacing: 0) {
                Spacer()
                if weightText == "" {
                    Text("0")
                        .opacity(0.2)
                        .transition(transition)
                } else {
//                    let _ = Self._printChanges()

                    ForEach(Array(weightText.map{ String($0) }.enumerated()), id: \.self.0) { (index, digit) in
//                        let digit = weight.components[index]
                        Text(digit)
                            .transition(transition)
                            .id(digit == "." ? "." : "\(digit) \(index)")

                    }
//                    if weightKeyboard.decimalActive {
//                        Text(".")
//                            .transition(transition)
//                        if weight.decimalOne != 0 || weightKeyboard.digitLocation == .decimalTwo {
//                            Text(String(weight.decimalOne))
//                                .transition(transition)
//
//                        }
//                        if weight.decimalTwo != 0 {
//                            Text(String(weight.decimalTwo))
//                                .transition(transition)
//                        }
//                    }
//                    .transition(transition)
//                    Text(String(weight.decimalOne))
//                        .id("\(weight.decimalOne) -1")
//                    Text(String(weight.decimalTwo))
//                        .id("\(weight.decimalTwo) -1")
                }

                Text(" lb")
                Spacer()
            }
            .padding(.vertical, 3)
            .padding(.bottom, 3)

        }
        .buttonStyle(.generic)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.3))
        }
        
        .overlay {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    Button {
                        weight -= increment
                    } label: {
                        Text("-\(increment.text)")
                            .contentShape(Rectangle())
                    }
                    Color.white.opacity(0.2)
                        .frame(width: 1, height: 26)
                    Spacer(minLength: 0)
                    Color.white.opacity(0.2)
                        .frame(width: 1, height: 26)
                    Button {
                        weight += increment
                    } label: {
                        Text("+\(increment.text)")
                    }

                }
                .buttonRepeatBehavior(.enabled)
                .buttonStyle(IncrementButtonStyle(height: geo.size.height))
            }
            
        }
//        .animation(animation, value: weight)
        .animation(animation, value: weightText)

        .customFont(size: 40)
        
//        .sensoryFeedback(.selection, trigger: weight)
//        .sensoryFeedback(.selection, trigger: digitLocation)
    }
    
    struct IncrementButtonStyle: ButtonStyle {
        var height: CGFloat
        
        private let padding: CGFloat = 16
        
        func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .customFont(size: 20)
                    .opacity(configuration.isPressed ? 0.5 : 1)
                    .frame(height: height - padding*2)
                    .padding(padding)
                    .contentShape(Rectangle())
                    .animation(.default, value: configuration.isPressed)
        }
    }
}
