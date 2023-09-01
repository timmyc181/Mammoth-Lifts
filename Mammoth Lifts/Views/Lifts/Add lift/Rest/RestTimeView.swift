import SwiftUI

struct RestTimeView: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    @State var pickerVisible = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            RestTimeTextView(minutes: minutes, seconds: seconds)
                .allowsHitTesting(false)
            if !pickerVisible {
                RestTimePresetsView(minutes: $minutes, seconds: $seconds, pickerVisible: $pickerVisible)
                    .transition(.scale(0.9).combined(with: .opacity))

            }
            
            if pickerVisible {
                DurationPickerView(minute: $minutes, second: $seconds, height: 200, fontSize: 27)
                    .transition(.scale(0.9).combined(with: .opacity))
//                    .transition(
//                        .asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top))
//                    )
//                    .padding(.top, 20)
            }
            Spacer()



        }
        .animation(.bouncy(duration: 0.35), value: pickerVisible)
        .background {
            Color.clear.contentShape(Rectangle())
                .onTapGesture {
                    pickerVisible = false
                }
        }
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
