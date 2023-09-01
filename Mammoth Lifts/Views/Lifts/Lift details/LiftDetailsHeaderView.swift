//

import SwiftUI

struct LiftDetailsHeaderView: View {
    var name: String
    
    var body: some View {
        VStack {
            Image("\(name) icon")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.accentColor)

            Text(name)
                .customFont(size: 28)
        }

    }
}

#Preview {
    LiftDetailsHeaderView(name: "deadlift")
}
