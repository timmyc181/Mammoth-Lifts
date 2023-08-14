//

import SwiftUI

struct DeleteLiftConfirmationView: View {
    @Environment(\.navigation) private var navigation
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 10) {
            Button {
                modelContext.delete(navigation.liftToDelete!)
                navigation.liftToDelete = nil
            } label: {
                Text("Delete")
            }
            .buttonStyle(
                FilledButtonStyle(
                    stretch: true,
                    foregroundColor: FilledButtonStyle.accentForegroundColor,
                    backgroundColor: Color(.trash)
                )
            )
            
            Button {
                navigation.liftToDelete = nil
            } label: {
                Text("Cancel")
            }
            .buttonStyle(
                FilledButtonStyle(
                    stretch: true,
                    foregroundColor: FilledButtonStyle.secondaryForegroundColor,
                    backgroundColor: FilledButtonStyle.secondaryBackgroundColor
                )
            )

        }

    }
}

#Preview {
    DeleteLiftConfirmationView()
}
