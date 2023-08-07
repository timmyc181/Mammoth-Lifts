//

import SwiftUI

struct SheetCloseIcon: View {
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            Circle()
                .fill(.white.opacity(0.1))
                .frame(width: 30, height: 30)
                .overlay {
                    Image("CloseIcon")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.white.opacity(0.9))
                }
                .expandTouchArea()
        }
        .buttonStyle(SheetCloseIconButtonStyle())
    }
}


struct SheetCloseIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .animation(Constants.sheetPresentationAnimation, value: configuration.isPressed)
    }
}


#Preview {
    ContentView()
}
