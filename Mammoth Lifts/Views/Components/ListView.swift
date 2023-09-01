//

import SwiftUI

struct ListView<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.listBackground))
        }
    }
}


struct ListItemView<Content: View>: View {
    var divider: Bool = true
    var sidePadding: Bool = true
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                content
                    .customFont(.list)
            }
            .padding(.vertical, 12)
            .safeAreaPadding(.horizontal, sidePadding ? 20 : 0)
            if divider {
                Rectangle()
                    .fill(Color(.border))
                    .frame(height: 1)
//                    .padding(.leading, 25)
            }
        }

    }
}


//#Preview {
//    ZStack {
//        Color.sheetBackground.ignoresSafeArea()
//        SetsRepsView(lift: .template(for: .bench))
//
//    }
//}
