//

import SwiftUI

struct ChooseLiftItemView: View {
    var lift: Lift.Option
    
    var body: some View {
        ZStack {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color(.cardBackground))
//                .frame(height: 200)

            ZStack {

//                    .frame(height: 60)
                VStack {
                    Image("\(lift.rawValue) icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.accentColor.opacity(1))
//                        .padding(.vertical, -30)
//                        .opacity(0.1)
                        .frame(height: 50)
//                        .padding(.trailing)
//                        .offset(y: 20)
                    Text(lift.rawValue)
                        .customFont(size: 16, color: .white.opacity(1))
                        .multilineTextAlignment(.center)
////                    Spacer()
//                    Image(.chevronIcon)
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                        .accentGradientForeground()
                }

            }
//            .padding(.horizontal, 25)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.03))
//                    .overlay(alignment: .trailing) {
//                        
//                    }
//                    .clipped()
            }
//            .padding(20)
        }


        
    }
}

//#Preview {
//    ZStack {
//        Color(.background).ignoresSafeArea()
//        ChooseLiftItemView(lift: .deadlift)
//    }
//    
//    
//}


#Preview {
    AddLiftView()
        .environment(Navigation())
        .background {
            Color.sheetBackground
                .ignoresSafeArea()
        }
}
