//

import SwiftUI

struct DateTimeSelectorButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .customFont(.list)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white.opacity(0.1))
            }
            .animation(.smooth, value: configuration.isPressed)
    }
    
}
