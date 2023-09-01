//

import SwiftUI

struct LiftDetailsActionsView: View {
    var lift: Lift
    
    @Environment(\.navigation) private var navigation
    
    var body: some View {
        HStack(spacing: 20) {
            Button {
                start()
            } label: {
                VStack {
                    Image(systemName: "play.fill")
                        .font(.system(size: 16, weight: .heavy))
                    Text("Start")
                }
            }
            Button {
                log()
            } label: {
                VStack {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 16, weight: .heavy))
                    Text("Log")
                }
            }
            
        }
        .buttonStyle(EditLiftActionsButtonStyle())
    }
    
    func start() {
        navigation.liftDetailsPresented = false
        navigation.liftForWorkout = lift
    }
    
    func log() {
        navigation.liftToLog = lift
    }
}


struct EditLiftActionsButtonStyle: ButtonStyle {
    var height: CGFloat = ButtonStyleView.height
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(SecondaryAccentButtonStyle.backgroundColor)
                .frame(height: height)
            configuration.label
                .customFont(size: 14, color: SecondaryAccentButtonStyle.foregroundColor)
        }
        .buttonPressModifier(isPressed: configuration.isPressed)
    }
}

#Preview {
    DumbPreviewThing {
        LiftDetailsActionsView(lift: .template(for: .bench))
    }
}
