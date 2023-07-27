import Foundation
import SwiftUI


struct ChooseWeightScrollView: View {
    @Environment(AddLiftState.self) var addLiftState
    
    @State var isSetup: Bool = false

    var body: some View {
        GeometryReader { geo in
            VStack {
                
                // For spacing purposes
                ChooseWeightTextView()
                    .opacity(0)
                
                
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
                                if let initialWeight = addLiftState.exercise?.currentWeight {
                                    
                                    proxy.scrollTo(Int(initialWeight), anchor: .center)
                                    isSetup = true
                                }
                        
                            }

                    }

                }
                .padding(.top, 10)
                
                .onPreferenceChange(ScrollPreferenceKey.self) { value in
                    if isSetup {
                        let tick = (value + padding - (ChooseWeightMarkersView.spacing / 2)) / (ChooseWeightMarkersView.totalTickWidth)
                        
                        addLiftState.exercise?.currentWeight = max(
                            Float((tick * 4).rounded() / 4),
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
    AddLiftView()
        .environment(Navigation())
        .background {
            Color.sheetBackground
                .ignoresSafeArea()
        }
}
