//

import SwiftUI

struct SmallSheetView<Content: View>: View {
    @Binding var isPresented: Bool
    var title: String? = nil
    var closeMethod: CloseMethod = .button
    var safeAreaBottom: CGFloat? = nil
    @ViewBuilder var content: Content
    
    @State var offset: CGFloat = 0
    @State var offsetPadding: CGFloat = 0
    
    
    @Environment(\.navigation) private var navigation
    
    enum CloseMethod {
        case button, dragIndicator
    }
    
    var body: some View {
//            Spacer()
            let gesture = DragGesture.sheetDragGesture(
                offset: $offset,
                padding: $offsetPadding,
                isPresented: $isPresented,
                closeThreshold: 100)
            VStack {
                switch closeMethod {
                case .button:
                    ZStack {
                        HStack {
                            Spacer()
                            CloseSheetButton {
                                isPresented = false
                            }
                        }
                        if let title = title {
                            
                            Text(title)
                                .customFont()
                        }
                    }
                    .padding(15)
                case .dragIndicator:
                    SheetDragIndicator()
                        .padding(.top, 10)
                }
                    

                content
                    .padding(.vertical)

                    .safeAreaPadding(.horizontal, Constants.sheetPadding)
                    .safeAreaPadding(.bottom, safeAreaBottom ?? 0)
            }
            .padding(.bottom, offsetPadding)

            .background {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(.smallSheetBackground))
                    .ignoresSafeArea()
            }
        
            
            .gesture(gesture)

            .offset(y: offset)
//            .background {
//                Color.clear
//                    .contentShape(Rectangle())
//                    .gesture(
//                        DragGesture()
//                            .onChanged { gesture in
//                                withAnimation(.snappy(duration: 0.1)) {
//                                    if gesture.translation.height < 0 {
//                                        offset = 0
//                                        //                                            offsetPadding = -Common.rubberBandClamp(gesture.translation.height, coeff: 0.35, dim: geo.size.height, range: 0...(.infinity))
//                                    } else {
//                                        offset = gesture.translation.height
//                                    }
//                                }
//
//
//                            }
//                            .onEnded { gesture in
//                                let closeThreshold = 100.0
//                                if gesture.predictedEndTranslation.height > closeThreshold {
//                                    isPresented = false
//                                    offsetPadding = 0
//                                } else {
//                                    withAnimation(.smooth(duration: 0.4)) {
//                                        offset = 0
//                                        offsetPadding = 0
//                                    }
//                                }
//                            }
//                    )
//            }
            .zIndex(4)
            .ignoresSafeArea()
            
            
            .onChange(of: isPresented) { oldValue, newValue in
                if newValue {
                    offset = 0
                }
            }
            .transition(.move(edge: .bottom))
            .animation(Constants.sheetPresentationAnimation, value: isPresented)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
        .populatedPreviewContainer()
        .background {
            Color.background.ignoresSafeArea()
        }
}

