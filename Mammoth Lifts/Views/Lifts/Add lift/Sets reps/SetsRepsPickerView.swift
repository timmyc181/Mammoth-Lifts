//

import SwiftUI

struct SetsRepsPickerView: View {
    @Binding var sets: Int
    @Binding var reps: Int
    
    static var tickWidth: CGFloat = 30
    static var textWidth: CGFloat = 40
    static var spacing: CGFloat = 30
    
    var body: some View {
        
        ZStack {
            HStack(spacing: 0) {
                SetsRepsPickerMarkersView(value: $sets, alignment: .leading)
                SetsRepsPickerMarkersView(value: $reps, alignment: .trailing)
            }
//            .padding(.horizontal, 15)
//                .modifier(SetsRepsPickerLabelModifier(value: sets, isSets: true))
//                .modifier(SetsRepsPickerLabelModifier(value: reps, isSets: false))
            HStack(spacing: 10) {
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(height: 4)
                    .padding(.trailing)
                    .padding(.horizontal, 10)

//                Spacer()
                VStack(spacing: 0) {
                    Text(String(sets))
                        .customFont(size: 60)
                    Text("sets")
                        .customFont(color: .white.opacity(0.2))
                        .padding(.top, -10)

                }
                Spacer()
                Text("x")
                    .customFont(size: 50, color: .accentColor)
                    .offset(y: -2)
                Spacer()
                VStack(spacing: 0) {
                    Text(String(reps))
                        .customFont(size: 60)
                    Text("reps")
                        .customFont(color: .white.opacity(0.2))
                        .padding(.top, -10)

                }
//                Spacer()
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(height: 4)
                    .padding(.leading)
                    .padding(.horizontal, 10)
            }
            .allowsHitTesting(false)
//            .padding(.horizontal, 10)
//            .safeAreaPadding(.horizontal)
            .ignoresSafeArea()
//            .padding(.horizontal, 5)


        }
        .coordinateSpace(.named("picker"))
//        .ignoresSafeArea(edges: .horizontal)

    }
}


struct SetsRepsPickerMarkersView: View {
    @Binding var value: Int
    var alignment: Alignment
    
    let markerHeight: CGFloat = 4
    
    @State var adapterValue: String? = "-1"
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
//                    GeometryReader { contentGeo in
                        VStack(spacing: 30) {
                            
                            ForEach((1..<10).map{"\($0)"}, id: \.self) { index in
                                Rectangle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 20, height: markerHeight)
                                //                                    .visualEffect { content, geometry in
                                //                                        content
                                //                                            .opacity(contentFadeOpacity(in: geometry, height: geo.size.height))
                                //
                                ////                                            .scaleEffect(y: contentScale(in: geometry, height: geo.size.height))
                                //                                            .offset(y: contentOffset(in: geometry, height: geo.size.height))
                                //
                                //                                    }
                            }
                            //                            ForEach(1..<10) { index in
                            //                                Rectangle()
                            //                                    .fill(.white.opacity(0.05))
                            //                                    .frame(width: 20, height: markerHeight)
                            ////                                    .visualEffect { content, geometry in
                            ////                                        content
                            ////                                            .opacity(contentFadeOpacity(in: geometry, height: geo.size.height))
                            ////
                            //////                                            .scaleEffect(y: contentScale(in: geometry, height: geo.size.height))
                            ////                                            .offset(y: contentOffset(in: geometry, height: geo.size.height))
                            ////
                            ////                                    }
                            //                            }
                            
                        }
//                        .overlay {
//                            GeometryReader { geo in
//                                VStack(spacing: 30) {
//                                    ForEach(1..<10) { index in
//                                        Rectangle()
//                                            .fill(.white.opacity(0.1))
//                                            .frame(width: 20, height: markerHeight)
//                                    }
//                                }
//                                .offset(y: geo.size.height + 30)
//                            }
//                        }
//                        .overlay {
//                            GeometryReader { geo in
//                                VStack(spacing: 30) {
//                                    ForEach(1..<10) { index in
//                                        Rectangle()
//                                            .fill(.white.opacity(0.1))
//                                            .frame(width: 20, height: markerHeight)
//                                    }
//                                }
//                                .offset(y: -(geo.size.height + 30))
//                            }
//                        }
                        .scrollTargetLayout()
                        
                        .frame(maxWidth: .infinity, alignment: alignment)
                        .contentShape(Rectangle())
//                    }

                }
                .scrollPosition(id: $adapterValue)

                .safeAreaPadding(.vertical, ((geo.size.height - markerHeight) / 2))
//                .safeAreaPadding(.top, )

                .scrollTargetBehavior(.viewAligned)
                .sensoryFeedback(.selection, trigger: value)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        adapterValue = "\(value)"
                    })
                }
                .onChange(of: adapterValue) { oldValue, newValue in
                    value = Int(adapterValue ?? "-1") ?? -1

                }
                .mask {
                    LinearGradient(colors: [.clear, .black, .clear], startPoint: .top, endPoint: .bottom)
                }
            }

                


        }
        

    }
    
    func contentFadeOpacity(in geometry: GeometryProxy, height: CGFloat) -> Double {
        let yPos = geometry.frame(in: .named("picker")).midY * 2.0
        let offset = height - yPos
        
        let amount = (offset / height)
        
        let newfinal = Double(cos(amount))
        
        return newfinal

    }
    
    func contentOffset(in geometry: GeometryProxy, height: CGFloat) -> Double {
        let yPos = geometry.frame(in: .named("picker")).midY * 2.0
        let offset = height - yPos
        
        let amount = (offset / height) / Double.pi
        
        return -(Double(sin(amount * Double.pi)) * (height / 2)) + (offset / 2.0)
    }
}



struct SetsRepsPickerLabelModifier: ViewModifier {
    var value: Int
    var isSets: Bool
    
    func body(content: Content) -> some View {
        content
            .mask {
                LinearGradient(colors: [.clear, .black, .clear], startPoint: .top, endPoint: .bottom)
            }
            .overlay {
                HStack(spacing: SetsRepsPickerView.spacing) {
                    Group {
                        Color.clear
                            .frame(width: SetsRepsPickerView.tickWidth)
//                            .overlay {
//                                Rectangle()
//                                    .fill(Color.accentColor)
//                                    .frame(width: 50, height: 4)
//                                    .offset(x: isSets ? 5 : -5)
//                            }
                        
                        VStack(spacing: 0) {
                            Text(String(value))
                                .customFont(size: 60)
                            Text(isSets ? "sets" : "reps")
                                .customFont(color: .white.opacity(0.2))
                                .padding(.top, -10)

                        }
                        .frame(width: SetsRepsPickerView.textWidth)

                        
                    }
                    .rotation3DEffect(
                        .degrees(isSets ? 0 : 180),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                }
                .rotation3DEffect(
                    .degrees(isSets ? 0 : 180),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .allowsHitTesting(false)

            }
    }
}

#Preview {
    AddLiftPreviewView(state: .setsReps)
}
