//

import SwiftUI

struct SheetDragIndicator: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(.white.opacity(0.15))
            .frame(width: 36, height: 6)
    }
}

#Preview {
    DumbPreviewThing {
        SheetDragIndicator()
    }
}
