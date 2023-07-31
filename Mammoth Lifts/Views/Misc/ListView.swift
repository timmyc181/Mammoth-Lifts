//

import SwiftUI

struct ListView<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white.opacity(0.05))
        }
    }
}


struct ListItemView<Content: View>: View {
    var divider: Bool = true
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                content
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 25)
            if divider {
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(height: 1)
                    .padding(.leading, 25)
            }
        }

    }
}


#Preview {
    ZStack {
        Color.sheetBackground.ignoresSafeArea()
        SetsRepsView(lift: .templateFor(.bench))

    }
}
