//

import SwiftUI

struct DurationPickerView: View {
    @Binding var minute: Int
    @Binding var second: Int
    
    
    var minutes: Int = 10
    var seconds: Int = 60
    
    private let height: CGFloat = 175
    
    @State var textSize: CGSize = .zero
    
    var body: some View {
        HStack(spacing: 6) {
            Spacer()
            
            DurationScrollView(scrollPosition: $minute, numbers: minutes, textSize: textSize.height, height: height)

            Text("min")
                .customFont(size: 24, color: .accentColor)
                .backgroundSizingPreference()
                .onPreferenceChange(BackgroundPreferenceKey.self, perform: { size in
                    textSize = size
                })
                .allowsHitTesting(false)
                .padding(.trailing, 50)
            
            DurationScrollView(scrollPosition: $second, numbers: seconds, textSize: textSize.height, height: height)
            Text("sec")
                .customFont(size: 24, color: .accentColor)
                .allowsHitTesting(false)
            
            Spacer()
        }
        .sensoryFeedback(.selection, trigger: minute)
        .sensoryFeedback(.selection, trigger: second)
        .coordinateSpace(.named("picker"))
//        .border(Color.red)

    }
}


fileprivate struct DurationScrollView: View {
    @Binding var scrollPosition: Int
    
    var numbers: Int
    var textSize: CGFloat
    var height: CGFloat
    

    
    @State var adapterValue: String? = "-1"
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(alignment: .trailing, spacing: 4) {
                    
                    ForEach((0..<numbers).map {"\($0)"}, id: \.self) { number in
                        HStack {
                            Spacer(minLength: 0)
                            Text("\(number)")
                                .customFont(size: 24)
                                .visualEffect { content, geometry in
                                    content
                                        .opacity(contentOpacity(in: geometry, height: height))
                                        .scaleEffect(y: contentRotate(in: geometry, height: height))
//                                        .rotation3D(.degrees(contentRotate(in: geometry, height: height)), axis: (1, 0, 0))
                                        .offset(y: contentOffset(in: geometry, height: height))
//                                        .scaleEffect(contentScale(in: geometry, height: height), anchor: .trailing)
                                }
                        }
                        .frame(width: 50)
                    }
                }
                .scrollTargetLayout()
                .padding(.leading, 25)
                .padding(.trailing, 90)

                .padding(.bottom, (height - textSize) / 2)

                
                .overlay {
                    Color.clear
                        .contentShape(Rectangle())
                }
            }
        }
        .padding(.top, -(height + textSize) / 2)
        .safeAreaPadding(.top, height)

        .scrollPosition(id: $adapterValue)
        .scrollTargetBehavior(.viewAligned)
        .frame(height: textSize)
        .padding(.leading, -25)
        .padding(.trailing, -90)
        .scrollClipDisabled()
        
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                adapterValue = "\(scrollPosition)"
            })
        }
        .onChange(of: adapterValue) { oldValue, newValue in
            scrollPosition = Int(adapterValue ?? "-1") ?? -1

        }
        .frame(height: height)
//        
        .mask {
            VStack(spacing: 0) {
                LinearGradient(colors: [.black.opacity(0.2), .black.opacity(1)], startPoint: .top, endPoint: .bottom)
                Color.black.frame(height: textSize * 0.7)
                LinearGradient(colors: [.black.opacity(1), .black.opacity(0.2)], startPoint: .top, endPoint: .bottom)
            }
            .allowsHitTesting(false)
        }
    }
    
    
    func contentScale(in geometry: GeometryProxy, height: CGFloat) -> Double {
        let yPos = geometry.frame(in: .named("picker")).midY * 2.0
        let offset = height - yPos
        
        let amount = min(max(offset * 1.5 / height, -Double.pi), Double.pi)
        
        return Double(cos(amount)) * 0.5 + 0.5
    }
    
    func contentOpacity(in geometry: GeometryProxy, height: CGFloat) -> Double {
        let yPos = geometry.frame(in: .named("picker")).midY * 2.0
        let offset = height - yPos
        
        let amount = min(max(offset / 30.0, -Double.pi/2), Double.pi/2)

        let threshold = offset / height
                
        if threshold > Double.pi / 2 || threshold < -Double.pi / 2 {
            return 0
        }
        
        return max(Double(cos(amount)), 0) * 0.8 + 0.2

    }
    
    func contentRotate(in geometry: GeometryProxy, height: CGFloat) -> Double {
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
}



extension View {
    func backgroundSizingPreference() -> some View {
        self
            .background {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: BackgroundPreferenceKey.self, value: geo.size)
                }
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
    ZStack {
        Color.background.ignoresSafeArea()
        RestTimeView()
        
    }
        
}
