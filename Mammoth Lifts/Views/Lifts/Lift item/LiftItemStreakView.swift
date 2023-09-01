//

import SwiftUI

struct LiftItemStreakView: View {
    var count: Int
    
    var body: some View {
        if count > 2 {
            HStack(spacing: 2) {
                Text(String(count))
                    .customFont(size: 24)
                Image(systemName: "flame.fill")

            }
        }
    }
}

#Preview {
    LiftItemStreakView(count: 4)
}
