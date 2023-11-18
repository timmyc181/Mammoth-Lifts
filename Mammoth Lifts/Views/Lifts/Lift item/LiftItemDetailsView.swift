//

import SwiftUI

struct LiftItemDetailsView: View {
    var name: String
    var weight: Weight
    var lastCompleted: String
    
    @State private var oldWeight: Weight = Weight(0)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .customFont(size: 20, color: .white)
            
            ZStack(alignment: .leading) {
                Text(oldWeight.text + " l")
                    .customFont(size: 14, color: .white.opacity(0.3))
//                    .id(weight.clean)
                    .modifier(LiftWeightTransition(isFinal: false, value: oldWeight))
                    .animation(.spring, value: weight)
                Text(weight.text + " lb")
                    .customFont(size: 14, color: .white.opacity(0.3))
//                    .id(weight.clean)
                    .modifier(LiftWeightTransition(isFinal: true, value: oldWeight))//                    .transition(.liftWeight)
                    .animation(.spring, value: weight)
            }
            .onChange(of: weight) { oldValue, newValue in
                oldWeight = oldValue
            }
            
//                .keyframeAnimator(initialValue: AnimationValues(), trigger: weight) { content, value in
//                    content
//                        .scaleEffect(value.scale)
//                        .blur(radius: value.blur)
//                } keyframes: { _ in
//                    KeyframeTrack(\.scale) {
//                        SpringKeyframe(2, duration: 0.5)
//                        SpringKeyframe(1, duration: 0.5)
//                    }
//                }

        }
    }
}


struct LiftWeightTransition<Value: Equatable>: ViewModifier {
    var isFinal: Bool
    var value: Value
    
    var opacity: Double {
        isFinal ? 0 : 1
    }
    
    func body(content: Content) -> some View {
        content
//            .scaleEffect(1 - value)
            .keyframeAnimator(initialValue: AnimationValues(opacity: 1 - opacity), trigger: value) { content, value in
                content
                    .scaleEffect(value.scale)
                    .opacity(value.opacity)
            } keyframes: { _ in
                KeyframeTrack(\.scale) {
                    SpringKeyframe(1.5, duration: 0.3, spring: .bouncy)
//                    SpringKeyframe(1.8, duration: 0.1, startVelocity: 0)
                    SpringKeyframe(1, duration: 1, spring: .bouncy)
                }
                KeyframeTrack(\.opacity) {
//                    LinearKeyframe(opacity, duration: 0.1)
                    SpringKeyframe(1 - opacity, duration: 0.1)
                    LinearKeyframe(1 - opacity, duration: 0.1)

                }
            }
    }
}

struct LiftWeightOutTransition: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaleEffect(2)
    }
}

fileprivate struct AnimationValues {
    var scale: CGFloat = 1
    var opacity: CGFloat
}

struct Thing: View {
    @State private var weight: Weight = 125
    
    var body: some View {
        LiftItemDetailsView(name: Lift.Option.deadlift.rawValue, weight: weight, lastCompleted: "Last Friday")
            .onAppear {
                change()
            }
            
    }
    
    func change() {
        weight += 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            change()
        }
    }
}

#Preview {
    ZStack {
        Color.background.ignoresSafeArea()
        Thing()
        
    }
}
