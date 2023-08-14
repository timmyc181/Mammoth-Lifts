//

import SwiftUI

struct RestTimePresetsView: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    @Binding var pickerVisible: Bool
    
    
    var body: some View {
        Grid(horizontalSpacing: 20, verticalSpacing: 20) {
            GridRow {
                RestTimePresetsItemView {
                    Text("5")
                        .customFont(size: 30)
                    Text("min")
                } action: {
                    minutes = 5
                    seconds = 0
                }
                RestTimePresetsItemView {
                    Text("3")
                        .customFont(size: 30)
                    Text("min")
                } action: {
                    minutes = 3
                    seconds = 0
                }
            }
            GridRow {
                RestTimePresetsItemView {
                    Text("1.5")
                        .customFont(size: 30)
                    Text("min")
                } action: {
                    minutes = 1
                    seconds = 30
                }
                RestTimePresetsItemView {
                    Text("Custom")
                        .customFont()
                } action: {
                    pickerVisible = true
                }
            }

        }
                
    }
}

struct RestTimePresetsItemView<Content: View>: View {
    @ViewBuilder var content: Content
    var action: () -> ()
    
    var body: some View {
        Button(action: action) {

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(0.03))
                    .frame(height: 80)

                VStack(spacing: -5) {
                    //                Spacer()
                    content
                        .customFont(color: .accentColor)
                    //                Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
        }
        .buttonStyle(.generic)
        .transition(
            .scale(0.9).combined(with: .opacity)
        )
        
            
    }
}


#Preview {
    
    ZStack {
        @State var minutes = 5
        @State var seconds = 5
        Color(.background).ignoresSafeArea()
        RestTimeView(minutes: $minutes, seconds: $seconds)
    }
}

