//

import SwiftUI

struct ChooseLiftItemView: View {
    var lift: Lift.Option
    
    var body: some View {

        VStack {
            Image("\(lift.rawValue) icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor.opacity(1))
                .frame(height: 50)
            Text(lift.rawValue)
                .customFont(size: 16, color: .white.opacity(1))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.03))
        }


        
    }
}


#Preview {
    AddLiftPreviewView()
}
