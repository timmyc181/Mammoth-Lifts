//

import SwiftUI

struct LogWorkoutDurationPickerView: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    var body: some View {
        DurationPickerView(minute: $minutes, second: $seconds, minutesRange: 0...150)
            .contentShape(Rectangle())
    }
}
