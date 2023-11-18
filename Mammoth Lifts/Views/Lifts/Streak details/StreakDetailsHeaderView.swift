import SwiftUI
import SwiftData

struct StreakDetailsHeaderView: View {
    @Environment(\.streak) private var streak
    
    var count: Int { streak?.count ?? 0 }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(String(count))
                    .customFont(size: 105, color: Color(.streaks))
                    .transition(.scale(0.5).combined(with: .opacity))
                    .id("streak count \(count)")
//                    .frame(maxHeight: 20)
                Image(systemName: "flame.fill")
                    .font(.system(size: 80, weight: .heavy))
                    .foregroundColor(Color(.streaks))
//                    .opacity(0.5)
            }
//            Text("Streaks")
//                .customFont(size: 28)
//            Text("Streaks")
//                .customFont(size: 24)
        }
        .animation(.snappy, value: count)
       
    }
}

#Preview {
    StreakDetailsView()
        .populatedPreviewContainer()
}
