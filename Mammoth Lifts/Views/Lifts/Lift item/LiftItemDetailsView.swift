//

import SwiftUI

struct LiftItemDetailsView: View {
    var name: String
    var weight: Double
    var lastCompleted: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
//            HStack(spacing: 4) {
//
//                Spacer(minLength: 0)
//            }
            
            Text(name)
                .customFont(size: 20, color: .white)
            
            Text(weight.clean + " lb")
                .customFont(size: 14, color: .white.opacity(0.3))
//                Spacer(minLength: 0)
//            HStack(spacing: 4) {
//                Image("RecentIcon")
//                    .resizable()
//                    .frame(width: 12, height: 12)
//                    .foregroundColor(.white)
//                    .offset(y: 1)
//                Text(lastCompleted)
//                    .customFont(size: 14, color: .white)
//            }
//            .opacity(0.2)

        }
    }
}

#Preview {
    LiftItemDetailsView(name: Lift.Option.deadlift.rawValue, weight: 125, lastCompleted: "Last Friday")
}
