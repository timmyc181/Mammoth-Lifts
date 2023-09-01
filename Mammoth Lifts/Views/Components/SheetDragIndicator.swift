//

import SwiftUI

struct SheetDragIndicator: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(.white.opacity(0.2))
            .frame(width: 36, height: 5)
    }
}

#Preview {
    DumbPreviewThing {
        SheetDragIndicator()
    }
}
