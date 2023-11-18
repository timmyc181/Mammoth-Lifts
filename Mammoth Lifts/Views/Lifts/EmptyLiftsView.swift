//

import SwiftUI

struct EmptyLiftsView: View {
    @Environment(\.navigation) private var navigation
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Add a lift to get started")
                .customFont(size: 20)
            Button {
                navigation.addLiftPresented = true
            } label: {
                Text("Add lift")
                    .padding(.horizontal)
            }
            .buttonStyle(.accent)
            Spacer()
        }
    }
}

#Preview {
    ContentView()
        .emptyPreviewContainer()
//        .populatedPreviewContainer()
}
