//

import SwiftUI

struct WeightKeyboardOverlay: View {
    @Binding var weight: Double
    @Binding var visible: Bool
    var increment: Double
    
    @State private var offset: CGFloat = 0
    
    @State private var decimalActive: Bool? = nil
    
    private var weightComponents: Binding<WeightKeyboard.WeightComponents> {
        Binding {
//            weightComponents.wrappedValue
            WeightKeyboard.WeightComponents(weight: weight, decimalActive: decimalActive)
        } set: { components in
            weight = components.getWeight()
            decimalActive = components.decimalActive
        }

    }
//    @State private var weightComponents: WeightKeyboard.WeightComponents {
//        willSet {
//            self.weight = WeightKeyboard.weight(from: newValue)
//        }
//    }
    
    init(weight: Binding<Double>, visible: Binding<Bool>, increment: Double) {
        self._weight = weight
        self._visible = visible
        self.increment = increment
        
        
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer()
//                Rectangle()
//                    .fill(Color.black.opacity(visible ? 0.5 : 0))
//                    .ignoresSafeArea()
//                    .padding(.bottom, -(geo.safeAreaInsets.bottom + 10) - offset)
//                    .onTapGesture {
//                        visible = false
//                    }
//                    .allowsHitTesting(visible)
                if visible {
                    let gesture = DragGesture.sheetDragGesture(
                        offset: $offset,
                        isPresented: $visible,
                        closeThreshold: 100
                    )
                    
                    VStack {
                        SheetDragIndicator()
                            .padding(.bottom, 10)
                        WeightKeyboardWeightView(weight: $weight, weightComponents: weightComponents.wrappedValue, increment: increment)
                            .padding(.bottom, 20)
//                        Rectangle()
//                            .fill(Color(.border))
//                            .frame(height: 1)
                        WeightKeyboard(weightComponents: weightComponents)
                        
                    }
                    .safeAreaPadding(.horizontal, Constants.sheetPadding)
                    .padding(.bottom, geo.safeAreaInsets.bottom)
                    .padding(.top, 10)

                    .background(
                        .thinMaterial
                    )
                    .mask {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(.smallSheetBackground))
                    }

                    .offset(y: geo.safeAreaInsets.bottom + 10)
                    
                    .offset(y: offset)
                    .gesture(gesture)
                
                    .transition(.move(edge: .bottom))

                }
                
            }
            .frame(maxWidth: .infinity)
            .onChange(of: visible) { oldValue, newValue in
                if newValue {
                    offset = 0
                }
            }
            .background {
                Rectangle()
                    .fill(Color.black.opacity(visible ? 0.5 : 0))
                    .ignoresSafeArea()
//                    .padding(.bottom, -(geo.safeAreaInsets.bottom + 10) - offset)
                    .onTapGesture {
                        visible = false
                    }
                    .allowsHitTesting(visible)
            }
        }
    }
}



struct WeightKeyboardWeightView: View {
    @Binding var weight: Double
    var weightComponents: WeightKeyboard.WeightComponents
    var increment: Double
    
    private let transition: AnyTransition = .scale(scale: 0.5, anchor: .init(x: 0.5, y: 0.75)).combined(with: .opacity)
//    private let animation: Animation = .snappy(duration: 0.55)
    private let animation: Animation = .spring(duration: 0.25, bounce: 0, blendDuration: 0)
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            if weightComponents.whole.count == 0 {
                Text("0")
                    .opacity(0.2)
                    .transition(transition)
            }
            ForEach(0..<weightComponents.whole.count, id: \.self) { index in
                let digit = weightComponents.whole[index]
                Text(String(digit))
                    .id("\(digit) \(index)")
            }
            .transition(transition)
            if weightComponents.decimalActive {
                Text(".")
                    .opacity(weightComponents.decimal.count > 0 ? 1 : 0.2)
                if weightComponents.decimal.count >= 1 {
                    let decimal = weightComponents.decimal[0]
                    Text(String(decimal))
                        .transition(transition)
                        .id("\(decimal) \(-1)")
                    if weightComponents.decimal.count >= 2 {
                        let decimal = weightComponents.decimal[1]
                        Text(String(decimal))
                            .transition(transition)
                            .id("\(decimal) \(-2)")
                    }
                }
            }

            Text(" lb")
            Spacer()
        }
        .padding(.vertical, 3)
        .padding(.bottom, 3)
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
                        Text("-\(increment.clean)")
                    }
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 1, height: 26)
                    Spacer(minLength: 0)
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 1, height: 26)
                    Button {
                        weight += increment
                    } label: {
                        Text("+\(increment.clean)")
                    }

                }
                .buttonRepeatBehavior(.enabled)
                .buttonStyle(IncrementButtonStyle(height: geo.size.height))
            }
            
        }
        .animation(animation, value: weightComponents.whole)
        .animation(animation, value: weightComponents.decimal)
        .animation(animation, value: weightComponents.decimalActive)

        .customFont(size: 40)
        
        .sensoryFeedback(.selection, trigger: weightComponents)
    }
    
    struct IncrementButtonStyle: ButtonStyle {
        var height: CGFloat
        
        private let padding: CGFloat = 16
        
        func makeBody(configuration: Configuration) -> some View {
                configuration.label
//                    .foregroundColor(.accentColor)
                .customFont(size: 20)//, color: Color.accentColor)
                    .frame(height: height - padding*2)
//                    .background {
//                        RoundedRectangle(cornerRadius: 8)
//                            .fill(.white.opacity(0.1))
//                    }
                    
                    .contentShape(Rectangle())
                    .padding(padding)
//                    .border(Color.blue)
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 10)

                
        }
    }
}



fileprivate struct WKPreview: View {
    @State private var weight: Double = 200
    @State private var visible: Bool = true
    
    var weightComponents = WeightKeyboard.WeightComponents(whole: [5,0], decimal: [2,5])
    
    var body: some View {
        WeightKeyboardOverlay(weight: $weight, visible: $visible, increment: 2.5)
            .background(Color.red)

    }
}

#Preview {
    WKPreview()
}
