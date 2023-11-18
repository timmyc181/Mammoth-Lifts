import SwiftUI
import SwiftData

struct StreakDetailsView: View {
    var body: some View {
        VStack {
            StreakDetailsHeaderView()
                .padding(.top, 50)
                .padding(.bottom, 20)
            
            StreakDetailsBodyView()
            Spacer(minLength: 0)
        }
        .safeAreaPadding(.horizontal, Constants.sheetPadding)
    }
}

#Preview {
    DumbPreviewThing {
        StreakDetailsView()
    }
}
