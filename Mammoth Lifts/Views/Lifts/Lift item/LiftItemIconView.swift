//

import SwiftUI

struct LiftItemIconView: View {
    var name: String
    
    var body: some View {
        ZStack {
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.accentColor.opacity(0.05))

            Image("\(name) icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor.opacity(1))
                .padding(8)
        }
    }
}

#Preview {
    LiftItemPreviewView { lifts in
        LiftItemView(lift: lifts.first!)

    }
    .populatedPreviewContainer()
}
