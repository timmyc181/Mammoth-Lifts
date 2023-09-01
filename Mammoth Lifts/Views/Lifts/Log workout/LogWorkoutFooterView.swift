//

import SwiftUI

struct LogWorkoutFooterView: View {
    var log: () -> ()
    
    var body: some View {
        Button {
            log()
        } label: {
            Text("Log")
        }
        .buttonStyle(.accentStretch)
    }
}
