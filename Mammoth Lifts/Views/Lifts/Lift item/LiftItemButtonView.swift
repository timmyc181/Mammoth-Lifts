//

import SwiftUI

struct LiftItemButtonView: View {
    var body: some View {
//        RoundedRectangle(cornerRadius: 12, style: .continuous)
//            .fill(Color.accentColor)
//            .overlay {
//                Image("PlayIcon")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 16)
//                    .foregroundColor(Color("CardBackground"))
//
//            }
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.accentColor)
            Image("PlayIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 16)
                .foregroundColor(Color(.cardBackground))
        }


    }
}

#Preview {
    LiftItemButtonView()
        .frame(width: 50, height: 50)
}
