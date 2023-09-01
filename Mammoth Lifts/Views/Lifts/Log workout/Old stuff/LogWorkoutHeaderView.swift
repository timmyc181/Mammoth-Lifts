//

import SwiftUI

struct LogWorkoutHeaderView: View {
    var name: String
    
    @Environment(\.navigation) private var navigation
    
    var body: some View {
        ZStack {
            Text("Log " + name.lowercased())
                .customFont()
            HStack {
                Spacer()
                CloseSheetButton {
                    navigation.logWorkoutPresented = false
                }
            }
        }
    }
}

//#Preview {
//    LogWorkoutHeaderView()
//}
