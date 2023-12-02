import SwiftUI
import SwiftData

struct StreakCalendarView: View {
    var month: Date = Date()
    
    @Query private var workouts: [Workout]
    @AppStorage(UserSettings.streakDaysKey) var streakDays = 3
    
    @State private var count = 0
    
    var body: some View {
        let data = Streak.calendarDataFor(month: month, workouts: workouts, streakDays: streakDays)
        CalendarView(month: month) { day, date in
            StreakCalendarDayView(date: date, status: data[date]!)
        }
    }
}

struct StreakCalendarDayView: View {
    let date: Date
    let status: CalendarDayStatus
    
    @Environment(\.streak) private var streak
    @Query(sort: \Workout.date) private var workouts: [Workout]
    
    var day: Int {
        Calendar.current.component(.day, from: date)
    }
    
    var weekday: Int {
        Calendar.current.component(.weekday, from: date)
    }
    
    var isNextWorkoutToday: Bool {
        guard let streak else {
            return false
        }
        return Calendar.current.isDate(date, equalTo: streak.nextWorkoutDate, toGranularity: .day)
    }
    
    var isToday: Bool {
        return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .day)
    }
    
    var foregroundColor: Color {
        if case .workout(tail: _) = status {
            return .background
        }
        else if isNextWorkoutToday {
            if isToday {
                return .background
            }
            return .accentColor

        }
        if case .streak(tail: _) = status {
            if isToday {
                return .white
            }
            return Color(.streaks)
        }
        return .white.opacity(0.3)
    }
    
    var streakTail: CalendarDayTail? {
        switch status {
        case .nothing:
            return nil
        case .workout(let tail):
            return tail
        case .streak(let tail):
            return tail
        case .nextWorkout:
            return nil
        }
    }
    
    var leadingSmooth: Bool {
        if streakTail != nil {
            if day == 1 || weekday == 1 {
                return true
            }
        }
        return false
    }
    var trailingSmooth: Bool {
        if streakTail != nil {
            if weekday == 7 {
                return true
            }
        }
        return false
    }
    
    let smoothCornerRadius: CGFloat = 6

    
    var body: some View {
        Text(String(day))
            .customFont(size: 14, color: foregroundColor)
            .frame(width: 30, height: 30)
            .background {
                if case .workout(tail: _) = status {
                    Circle()
                        .fill(Color(.streaks))
                } else if isNextWorkoutToday {
                    Circle()
                        .fill(Color.accentColor.opacity(isToday ? 1 : 0.15))
                }
            }
            .background {
                if let streakTail {
                    if streakTail == .left {
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .fill(Color(.streaks).opacity(0.15))
                            .rotationEffect(.degrees(-90))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background {
                if let streakTail {
//                    let leftCornerRadius = 
                    Group {
                        switch streakTail {
                        case .left:
                            HStack(spacing: 0) {
                                Color(.streaks)
                                Color.clear

                            }
                        case .right:
                            HStack(spacing: 0) {
                                Color.clear
                                Color(.streaks)

                            }
                        case .both:
                            Color(.streaks)
                                
                        }
                    }
                    .opacity(0.15)
                    .clipShape(
                        .rect(
                            topLeadingRadius: leadingSmooth ? smoothCornerRadius : 0,
                            bottomLeadingRadius: leadingSmooth ? smoothCornerRadius : 0,
                            bottomTrailingRadius: trailingSmooth ? smoothCornerRadius : 0,
                            topTrailingRadius: trailingSmooth ? smoothCornerRadius : 0
                        )
                    )

                    
                }
            }
    }
    
}




struct CalendarView<DateView: View>: View {
    typealias DateViewComposer = (_ day: Int, _ date: Date) -> DateView
    
//    var interval: DateInterval
    
    var content: DateViewComposer?
    let weeks: [Int: [Date]]
    
    init(month: Date = Date(), @ViewBuilder content: @escaping DateViewComposer) {
        self.content = content
        self.weeks = month.weeksInMonth()
    }
    

    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 10) {
            HeaderView()
            ForEach(weeks.sorted { $0.key < $1.key}, id: \.key) { week, days in
                WeekView(week: week, days: days, dateView: content)
            }
        }
    }
}

extension CalendarView where DateView == EmptyView {
    init(month: Date = Date()) {
        self.content = nil
        self.weeks = month.weeksInMonth()
    }
}

struct WeekView<DateView: View>: View {
    let week: Int
    let days: [Date]
    let dateView: ((_ day: Int, _ date: Date) -> DateView)?
    
    var body: some View {
        GridRow {
            if week == 1 && days.count < 7 {
                Color.clear
                    .gridCellColumns(7 - days.count)
                    .gridCellUnsizedAxes([.horizontal, .vertical])
            }
            ForEach(0..<days.count, id: \.self) { i in
                Group {
                    if let dateView {
                        dateView(i, days[i])
                    } else {
                        defaultDateView(day: i, date: days[i])
                    }
                }
            }
        }

    }
    
    
    
    @ViewBuilder func defaultDateView(day: Int, date: Date) -> some View {
        Text(String(Calendar.current.component(.day, from: date)))
            .customFont(size: 14)
            .opacity(0.3)
            .frame(maxWidth: .infinity)
    }
}


fileprivate struct WeekPreferenceKey: PreferenceKey {
    typealias Value = [(anchor: Anchor<CGRect>, week: Int)]

    static var defaultValue: Value = []

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}





fileprivate struct HeaderView: View {
    let weekday = Calendar.current.component(.weekday, from: Date())
    
    var body: some View {
        GridRow {
            Group {
                Text("Su")
                    .opacity(weekday == 1 ? 1 : 0.3)
                Text("Mo")
                    .opacity(weekday == 2 ? 1 : 0.3)
                Text("Tu")
                    .opacity(weekday == 3 ? 1 : 0.3)
                Text("We")
                    .opacity(weekday == 4 ? 1 : 0.3)
                Text("Th")
                    .opacity(weekday == 5 ? 1 : 0.3)
                Text("Fr")
                    .opacity(weekday == 6 ? 1 : 0.3)
                Text("Sa")
                    .opacity(weekday == 7 ? 1 : 0.3)
            }
//            .fixedSize(horizontal: true, vertical: false)
            .gridCellUnsizedAxes(.horizontal)
//            .frame(maxWidth: .infinity)

        }
        .customFont(size: 14)
    }
    
    
}











extension Date {
    var firstDayOfMonth: Date {
        Calendar.current.date(from:
            Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    var endDateOfMonth: Date {
        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.firstDayOfMonth) else {
            fatalError("Unable to get end date from date")
        }
        return date
    }

    func weeksInMonth() -> [Int: [Date]] {
        var weeks = [Int: [Date]]()

        let range = Calendar.current.range(of: .day, in: .month, for: self)!

        var day = firstDayOfMonth

        for _ in 1...range.count {
            let weekInMonth = Calendar.current.component(.weekOfMonth, from: day)
            
            if weeks[weekInMonth]?.append(day) == nil {
                weeks[weekInMonth] = [day]
            }
            day = day.adding(days: 1)
        }

        return weeks
    }
    func daysInMonth() -> [Date] {
        var days = [Date]()

        let range = Calendar.current.range(of: .day, in: .month, for: self)!

        var day = firstDayOfMonth

        for _ in 1...range.count {
            days.append(day)
            day = day.adding(days: 1)
        }

        return days
    }
}


#Preview {
//    CalendarView { day, date in
//        Rectangle()
//            .frame(width: 20, height: 20)
//            .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
//            .opacity(0.1)
//    }    
//    CalendarView { day, date in
//        Rectangle()
//            .frame(width: 20, height: 20)
//            .cornerRadius(4)
//            .opacity(0.1)
//    }
    StreakCalendarView()
        .populatedPreviewContainer()
}
