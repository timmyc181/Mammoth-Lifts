import SwiftUI

struct DurationPickerView: View {
    @Binding var minute: Int
    @Binding var second: Int
    
    var height: CGFloat? = 175

    var fontSize: CGFloat = 24
    
    @Environment(\.durationPickerType) var pickerType

    var body: some View {
        switch pickerType {
        case .graphical:
            GraphicalDurationPickerView(minute: $minute, second: $second, height: height, fontSize: fontSize)
        case .compact:
            CompactDurationPickerView(minute: $minute, second: $second)
        }
    }
}

struct CompactDurationPickerPopoverContainerView: View {
    var value: CompactDurationPickerPreferenceKey.Value

    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if let value {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture {
                            value.isPresented.wrappedValue = false
                        }
                        .zIndex(0)
                }
                if let value {
                    CompactDurationPickerPopoverView(minute: value.minute, second: value.second, position: value.position, geometry: geometry)
                        .zIndex(1)
                }
            }
            .animation(Constants.datePickerAnimation, value: value == nil)
        }
        .ignoresSafeArea()
    }
    

}

struct CompactDurationPickerPopoverView: View {
    @Binding var minute: Int
    @Binding var second: Int
    var position: Anchor<CGPoint>
    var geometry: GeometryProxy
    
    private let width: CGFloat = 260
    private let height: CGFloat = 200
    private let padding: CGFloat = 20
    
    private var anchorPoint: UnitPoint {
        UnitPoint(x: geometry[position].x/geometry.size.width, y: (geometry[position].y - spacing) / geometry.size.height)
        
    }
    
    private let spacing: CGFloat = 10
    
    var body: some View {
        VStack {
            
            GraphicalDurationPickerView(minute: $minute, second: $second, fontSize: 24)
                .padding()
            
        }
        .frame(width: width, height: height)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 25))
        .position(x: geometry.size.width / 2, y: geometry[position].y - height / 2 - spacing)
        
        .transition(.scale(0, anchor: anchorPoint).combined(with: .opacity))

    }
}




fileprivate struct CompactDurationPickerView: View {
    @Binding var minute: Int
    @Binding var second: Int
    
    @State private var isPresented: Bool = false
    
    var text: String {
        if second == 0 {
            return "\(minute) min"
        } else {
            return "\(minute)m \(second)s"
        }
    }
    
    var body: some View {
        Button {
            isPresented = true
        } label: {
            Text(text)
        }
        .buttonStyle(DateTimeSelectorButtonStyle())
        .anchorPreference(key: CompactDurationPickerPreferenceKey.self, value: .top) { position in
            (minute: $minute, second: $second, isPresented: $isPresented, position: position)
        }
    }
}

struct CompactDurationPickerPreferenceKey: PreferenceKey {
    typealias Value = (minute: Binding<Int>, second: Binding<Int>, isPresented: Binding<Bool>, position: Anchor<CGPoint>)?
    
    static var defaultValue: Value = nil
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        if let nextValue = nextValue(),
           nextValue.isPresented.wrappedValue == true {
            value = nextValue
        }
    }
}

extension View {
    func durationPickerType(_ pickerType: DurationPickerType) -> some View {
        environment(\.durationPickerType, pickerType)
    }
}

private struct DurationPickerTypeKey: EnvironmentKey {
    static let defaultValue = DurationPickerType.graphical
}

enum DurationPickerType {
    case graphical
    case compact
}

extension EnvironmentValues {
  var durationPickerType: DurationPickerType {
    get { self[DurationPickerTypeKey.self] }
    set { self[DurationPickerTypeKey.self] = newValue }
  }
}

fileprivate struct GraphicalDurationPickerView: View {
    @Binding var minute: Int
    @Binding var second: Int
    
    var height: CGFloat?

    var fontSize: CGFloat
    
    var minutesRange: ClosedRange<Int> = Constants.restTimeMinutesRange
    
    var secondsRange: ClosedRange<Int> = Constants.secondsRange

    @State private var textHeight: CGFloat = 29
    
    static var labelSpacing: CGFloat = 6
    static var sidePadding: CGFloat = 45
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Group {
                    ZStack(alignment: .leading) {
                        DurationScrollView(scrollPosition: $minute, range: minutesRange, textHeight: textHeight, text: "min", alignment: .leading)

                        Text("min")
                            .foregroundStyle(Color.white.opacity(0.3))
                            .backgroundSizingPreference()
                            .onPreferenceChange(BackgroundPreferenceKey.self, perform: { size in
                                textHeight = size.height
                            })
                            .allowsHitTesting(false)
                            .padding(.leading, DurationScrollView.textWidth + Self.labelSpacing + Self.sidePadding - 20)

                    }
                    
                    ZStack(alignment: .trailing) {
                        DurationScrollView(scrollPosition: $second, range: secondsRange, textHeight: textHeight, text: "sec", alignment: .trailing)
                        Text("sec")
                            .foregroundStyle(Color.white.opacity(0.3))
                            .allowsHitTesting(false)
                            .padding(.trailing, Self.sidePadding)
                    }
                }
                

                
            }
            .customFont(size: fontSize)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.05))
                    .frame(height: textHeight + 8)
            }
            .sensoryFeedback(.selection, trigger: minute)
            .sensoryFeedback(.selection, trigger: second)
            .coordinateSpace(.named("picker"))
        }
        .frame(height: height)
    }
}


fileprivate struct DurationScrollView: View {
    @Binding var scrollPosition: Int
    
    var range: ClosedRange<Int>
    var textHeight: CGFloat
    var text: String
    var alignment: Alignment

    
    @State var adapterValue: Int? = -1
    
    static var textWidth: CGFloat = 40
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                ScrollViewReader { proxy in
                    VStack(alignment: .trailing, spacing: 6) {
                        ForEach((range), id: \.self) { number in
                            Text("\(number)")
                                .visualEffect { content, geometry in
                                    content
                                        .opacity(contentSelectionOpacity(in: geometry, height: geo.size.height))
                                        .opacity(contentFadeOpacity(in: geometry, height: geo.size.height))

                                        .rotationEffect(.degrees(contentRotate(in: geometry, height: geo.size.height)))

                                        .scaleEffect(y: contentScale(in: geometry, height: geo.size.height))
                                        .offset(y: contentOffset(in: geometry, height: geo.size.height))
                                        .offset(x: contentOffsetX(in: geometry, height: geo.size.height))

                                }
                                .frame(width: Self.textWidth, alignment: .trailing)
//                                .overlay {
//                                    Text("\(textHeight)")
//                                        .customFont()
//                                        .offset(x: 20)
//                                }

                        }
                    }
                    .padding(alignment == .leading ? .leading : .trailing, alignment == .leading ? GraphicalDurationPickerView.sidePadding - 20 : GraphicalDurationPickerView.sidePadding)
                    .safeAreaInset(edge: .trailing, spacing: GraphicalDurationPickerView.labelSpacing) {
                        Text(text)
                            .opacity(0)
                    }
                    .scrollTargetLayout()
                    .frame(maxWidth: .infinity, alignment: alignment)
                    .padding(.vertical, (geo.size.height - textHeight) / 2)
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//        //                    adapterValue = "\(scrollPosition)"
//                            proxy.scrollTo(scrollPosition, anchor: .init(x: 0, y: 0.5 - (textHeight / geo.size.height)))
//
//        //
//                        })
//                    }

                }
            }
            .scrollTargetBehavior(.viewAligned)
//            .safeAreaPadding(.vertical, (geo.size.height - textHeight) / 2)
            .scrollPosition(id: Binding<Int?>(
                get: {
                    scrollPosition
                }, set: { newVal in
                    scrollPosition = newVal ?? -1
                }
            ), anchor: .bottom)
            .onAppear {
                adapterValue = scrollPosition

//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                    adapterValue = "\(scrollPosition)"
//
//                })
            }
            .onChange(of: adapterValue) { oldValue, newValue in
                scrollPosition = adapterValue ?? -1

            }
        }
        
    }
    
    func contentSelectionOpacity(in geometry: GeometryProxy, height: CGFloat) -> Double {
        let yPos = geometry.frame(in: .named("picker")).midY * 2.0
        let offset = height - yPos
        
        let amount = min(max(offset / 20.0, -Double.pi), Double.pi)

        let threshold = offset / height
                
        if threshold > Double.pi / 2 || threshold < -Double.pi / 2 {
            return 0
        }
        
        return Double(cos(amount)) * 0.45 + 0.55

    }
    
    func contentFadeOpacity(in geometry: GeometryProxy, height: CGFloat) -> Double {
        let yPos = geometry.frame(in: .named("picker")).midY * 2.0
        let offset = height - yPos
        
        let amount = (offset / height)
        
        let newfinal = Double(cos(amount))
        
        return newfinal

    }
    
    func contentScale(in geometry: GeometryProxy, height: CGFloat) -> Double {
        let yPos = geometry.frame(in: .named("picker")).midY * 2.0
        let offset = height - yPos
        
        let amount = (offset / height)
        
        return Double(cos(amount))

    }
    
    
    func contentOffset(in geometry: GeometryProxy, height: CGFloat) -> Double {
        let yPos = geometry.frame(in: .named("picker")).midY * 2.0
        let offset = height - yPos
        
        let amount = (offset / height) / Double.pi
        
        return -(Double(sin(amount * Double.pi)) * (height / 2)) + (offset / 2.0)
    }
    
    let xScaleWeighting: CGFloat = 5
    
    func contentOffsetX(in geometry: GeometryProxy, height: CGFloat) -> Double {
        let yPos = geometry.frame(in: .named("picker")).midY * 2.0
        let offset = height - yPos
        
        let amount = (offset / height) / Double.pi
        
        return (alignment == .leading ? -1.0 : 1.0) * ((Double(cos(amount * Double.pi)) * xScaleWeighting) - xScaleWeighting)
    }
    
    func contentRotate(in geometry: GeometryProxy, height: CGFloat) -> Double {
        let yPos = geometry.frame(in: .named("picker")).midY * 2.0
        let offset = height - yPos
        
        let amount = (offset / height) / Double.pi
        
        let newXScaleWeighting = xScaleWeighting
        
        let alignmentSign = (alignment == .leading ? -1.0 : 1.0)
        
        let angleSign =
        amount
            .rounded(.down)
            .truncatingRemainder(dividingBy: 2) == 0 ? -1.0 : 1.0
        
        let initialValue = Double(cos(amount * Double.pi * 2))
                          
        return alignmentSign * angleSign * ((1 - initialValue) * newXScaleWeighting / 5.0)
    }
}

struct CustomScrollTargetBehavior: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if context.velocity.dy > 0 {
            target.rect.origin.y = context.originalTarget.rect.maxY
        } else if context.velocity.dy < 0 {
            target.rect.origin.y = context.originalTarget.rect.minY
        }
    }
}

extension ScrollTargetBehavior where Self == CustomScrollTargetBehavior {
    static var custom: CustomScrollTargetBehavior { .init() }
}


extension View {
    func backgroundSizingPreference() -> some View {
        self
            .overlay {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: BackgroundPreferenceKey.self, value: geo.size)
                }
//                .border(Color.red)
            }
        
    }
}


struct BackgroundPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}


#Preview {
    AddLiftPreviewView(state: .rest)
}
