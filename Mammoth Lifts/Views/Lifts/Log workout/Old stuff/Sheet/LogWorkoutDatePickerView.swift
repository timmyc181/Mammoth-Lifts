//

import SwiftUI

struct LogWorkoutDatePickerView: View {
    @Binding var date: Date
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2021, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
    var body: some View {
        DatePicker(
            "Pick date",
            selection: $date,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    ZStack {
        Color.sheetBackground.ignoresSafeArea()
        LogWorkoutDatePickerView(date: .constant(Date()))
    }
}
