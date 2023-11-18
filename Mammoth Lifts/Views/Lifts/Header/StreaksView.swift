import SwiftUI
import SwiftData

struct StreaksView: View {
    var fontSize: CGFloat
    
    @Environment(\.streak) private var streak
    var count: Int { streak?.count ?? 0 }
    
    var body: some View {
        
        HStack {
            let color = streak != nil ? Color(.streaks) : .white.opacity(0.15)
            HStack(spacing: 0) {
                    Text(String(count))
                        .customFont(size: fontSize, color: color)
                        .transition(.scale.combined(with: .opacity))
                        .id("streak count \(count)")
                        .frame(maxHeight: 20)
                    Image(systemName: "flame.fill")
                    .font(.system(size: fontSize * 0.75, weight: .heavy))
                        .foregroundColor(color)
                        
            }
            .transition(.scale.combined(with: .opacity))
                
        }
        .animation(.bouncy, value: count)
    }
}



#Preview {
    StreaksView(fontSize: 20)
}
