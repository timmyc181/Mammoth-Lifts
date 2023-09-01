//

import SwiftUI

struct LogWorkoutTimePickerView: View {
    @Binding var date: Date
    
    var body: some View {
//        DurationPickerView(minute: $minutes, second: $seconds)
        DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
            .datePickerStyle(.wheel)
            .contentShape(Rectangle())
            .environment(\.colorScheme, .dark)
    }
}
