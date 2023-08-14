import SwiftUI

struct DurationPickerView: View {
    @Binding var minute: Int
    @Binding var second: Int
    
    var height: CGFloat? = 175

    var fontSize: CGFloat = 20
    
    var minutes: Int = 10
    var seconds: Int = 60
    
    
    @State var textHeight: CGFloat = 29
    
    static var labelSpacing: CGFloat = 6
    static var sidePadding: CGFloat = 45
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                Group {
                    ZStack(alignment: .leading) {
                        DurationScrollView(scrollPosition: $minute, range: 0..<minutes, textHeight: textHeight, text: "min", alignment: .leading)

                        Text("min")
                            .foregroundStyle(Color.accentColor)
                            .backgroundSizingPreference()
                            .onPreferenceChange(BackgroundPreferenceKey.self, perform: { size in
                                textHeight = size.height
                            })
                            .allowsHitTesting(false)
                            .padding(.leading, DurationScrollView.textWidth + Self.labelSpacing + DurationPickerView.sidePadding - 20)

                    }
                    
                    ZStack(alignment: .trailing) {
                        DurationScrollView(scrollPosition: $second, range: 0..<seconds, textHeight: textHeight, text: "sec", alignment: .trailing)
                        Text("sec")
                            .foregroundStyle(Color.accentColor)
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
    
    var range: Range<Int>
    var textHeight: CGFloat
    var text: String
    var alignment: Alignment

    
    @State var adapterValue: String? = "-1"
    
    static var textWidth: CGFloat = 40
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                ScrollViewReader { proxy in
                    VStack(alignment: .trailing, spacing: 6) {
                        ForEach((range).map {"\($0)"}, id: \.self) { number in
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

                        }
                    }
                    .padding(alignment == .leading ? .leading : .trailing, alignment == .leading ? DurationPickerView.sidePadding - 20 : DurationPickerView.sidePadding)
                    .safeAreaInset(edge: .trailing, spacing: DurationPickerView.labelSpacing) {
                        Text(text)
                            .opacity(0)
                    }
                    .scrollTargetLayout()
                    .frame(maxWidth: .infinity, alignment: alignment)
//                    .offset(y: (geo.size.height - textHeight) / 2)
//                    .padding(.top, -100)

//                    .padding(.bottom, (geo.size.height - textHeight) / 2)
//                    .padding(.top, (geo.size.height - textHeight) / 2)

//                    .padding(.bottom, 50)
//                    .padding(.vertical, (geo.size.height - textHeight) / 2)
//                    .safeAreaInset(edge: .top) {
//                        Color.clear.frame(height: (geo.size.height - textHeight) / 2)
//                    }
//                    .safeAreaInset(edge: .bottom) {
//                        Color.clear.frame(height: (geo.size.height - textHeight) / 2)
//                    }
                }
            }
//            .contentMargins(.vertical, (geo.size.height - textHeight) / 2)
//            .scrollPosition(id: $adapterValue, anchor: .center)
//            .safeAreaPadding(.vertical, 51)
//            .safeAreaPadding(.top, (geo.size.height) / 2)

//            .padding(.top, 100)
//            .safeAreaPadding(.vertical, (geo.size.height - textHeight) / 2)
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.vertical, (geo.size.height - textHeight) / 2)

//            .frame(height: textHeight)


//            .scrollClipDisabled()
//            .frame(height: 200)

//            .scrollPosition(id: Binding<String?>(get: {
//                String(scrollPosition)
//            }, set: { newValue in
//                scrollPosition = Int(newValue ?? "-1") ?? -1
//            }), anchor: .center)
//            .scrollClipDisabled()
//            .safeAreaPadding(.top, 52)
//            .padding(.top, 50)

            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    adapterValue = "\(scrollPosition)"
                })
            }
            .onChange(of: adapterValue) { oldValue, newValue in
                scrollPosition = Int(adapterValue ?? "-1") ?? -1

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
