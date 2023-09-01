//

import SwiftUI

struct LiftItemWeight: View {
    var weight: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(weight)
                .customFont(size: 18, color: Color.accentColor)
                .offset(y: 1)
            Text(" lb")
                .customFont(size: 14, color: .white.opacity(0.2))
                .offset(y: -1)
        }
    }
}

#Preview {
    LiftItemWeight(weight: "350")
}
