//

import SwiftUI

struct RestTimeTextView: View {
    var minutes: Int
    var seconds: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(minutes)")
//                .foregroundStyle(Color.accentColor)

            Text(":")
                .offset(y: -7)
//                .opacity(0.4)
//                .foregroundColor(.accentColor)
            Text("\(String(format: "%02d", seconds))")
//                .foregroundStyle(Color.accentColor)

        }
       
            .customFont(size: 60)
    }
}

#Preview {
    ZStack {
        @State var minutes = 5
        @State var seconds = 5
        Color(.sheetBackground).ignoresSafeArea()
        RestTimeView(minutes: $minutes, seconds: $seconds)
    }
}

