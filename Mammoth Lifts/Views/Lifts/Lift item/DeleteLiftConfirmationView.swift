//

import SwiftUI

struct DeleteLiftConfirmationView: View {
    var delete: () -> ()
    var close: () -> ()
    
    var body: some View {
        VStack(spacing: 10) {
            Button {
                delete()
            } label: {
                Text("Delete")
            }
            .buttonStyle(
                AccentButtonStyle(stretch: true, backgroundColor: Color(.error))
            )
            
            Button {
                close()
            } label: {
                Text("Cancel")
            }
            .buttonStyle(.secondaryStretch)

        }

    }
}

//#Preview {
//    DeleteLiftConfirmationView()
//}
