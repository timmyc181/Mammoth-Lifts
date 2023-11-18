//

import SwiftUI

struct ListView<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background {
            Color(.listBackground)
        }
        .cornerRadius(16)
    }
}


struct ListItemView<Content: View>: View {
    var divider: Bool = true
    var sidePadding: Bool = true
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                content()
                    .customFont(.list)
                Spacer(minLength: 0)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, sidePadding ? 20 : 0)
            .frame(maxWidth: .infinity)

            if divider {
                Rectangle()
                    .fill(Color(.border))
                    .frame(height: 1)
//                    .padding(.leading, 25)
            }
        }

    }
}


#Preview {
    ListView {
        ListItemView(divider: false) {
            Text("Hello")
                .customFont()
        }
    }
}
