//

import SwiftUI

struct SmallSheetView<Content: View>: View {
    @Binding var isPresented: Bool
    @ViewBuilder var content: Content
    
    @State var offset: CGFloat = 0
    @State var offsetPadding: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Color.black.opacity(isPresented ? 0.5 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                    }
                if isPresented {
                    VStack {
                        ZStack {
                            HStack {
                                Spacer()
                                SheetCloseIcon {
                                    isPresented = false
                                }
                            }
                            Text("Sets and reps")
                                .customFont()
                        }
                        .padding(15)
                        .padding(.bottom, 10)
                        content
                            .padding(.vertical)
                            .padding(.horizontal, Constants.sheetPadding)

                    }
                    .padding(.bottom, 60)
                    .padding(.bottom, geo.safeAreaInsets.bottom)
                    .padding(.bottom, offsetPadding)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color(.smallSheetBackground))
                            .ignoresSafeArea()
                    }
                    .offset(y: offset)
                    .transition(.move(edge: .bottom))
                    .zIndex(4)

                }

                
            }
            .ignoresSafeArea()

            .animation(Constants.sheetPresentationAnimation, value: isPresented)
            .gesture(
                DragGesture()
                    
                    .onChanged { gesture in
                        if gesture.translation.height < 0 {
                            offset = 0
                            offsetPadding = -Common.rubberBandClamp(gesture.translation.height, coeff: 0.2, dim: geo.size.height)
                        } else {
                            offset = gesture.translation.height
                        }

                    }
                    .onEnded { gesture in
                        let closeThreshold = 100.0
                        if gesture.predictedEndTranslation.height > closeThreshold {
                            isPresented = false
                            offsetPadding = 0
                        } else {
                            withAnimation(.smooth(duration: 0.4)) {
                                offset = 0
                                offsetPadding = 0
                            }
                        }
                    }
            )
            .onChange(of: isPresented) { oldValue, newValue in
                if newValue {
                    offset = 0
                }
            }
        }
        .allowsHitTesting(isPresented)
        
    }
}


