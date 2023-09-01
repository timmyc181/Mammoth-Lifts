import Foundation
import SwiftUI


struct ChooseWeightScrollView: View {
    @Binding var weight: Double
    
    @State var isSetup: Bool = false

    var body: some View {
        GeometryReader { geo in
            VStack {
                
                // For spacing purposes
                ChooseWeightTextView.spacingView
                
                let padding = geo.size.width / 2 - 2
                
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { proxy in

                        ChooseWeightMarkersView()
                            .padding(.leading, padding)
                            .padding(.trailing, padding)
                            .offset(x: -ChooseWeightMarkersView.spacing / 2)

                            .contentShape(Rectangle())
                            .frame(maxHeight: .infinity)
                            .onAppear {
//                                if let initialWeight = weight {
                                    
                                    proxy.scrollTo(Int(weight), anchor: .center)
                                    isSetup = true
//                                }
                        
                            }

                    }
                    .sheetGestureOverride()

                }
//                .coordinateSpace(.named("container"))
                .padding(.top, 10)
                
                .onPreferenceChange(ScrollPreferenceKey.self) { value in
                    if isSetup {
                        let tick = (value + padding - (ChooseWeightMarkersView.spacing / 2)) / (ChooseWeightMarkersView.totalTickWidth)
                        
                        weight = max(
                            Double((tick * 4).rounded() / 4),
                            0
                        )
                    }

                }
                
                .overlay {
                    HStack {
                        LinearGradient(colors: [.sheetBackground, .sheetBackground.opacity(0)], startPoint: .leading, endPoint: .trailing)
                        Color.clear
                        LinearGradient(colors: [.sheetBackground, .sheetBackground.opacity(0)], startPoint: .trailing, endPoint: .leading)
                    }
                    .allowsHitTesting(false)
                }
            }
        }
        
    }
}

#Preview {
    AddLiftPreviewView(state: .weight)

}
