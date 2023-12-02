//

import SwiftUI

struct StreakDetailsNextWorkoutView: View {
    var date: Date
    
    var dateString: String {
        date.relativeDateString
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: "clock")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color(.accent))
                .font(.system(size: 18, weight: .heavy))
                .padding(.top, 2)
            VStack(alignment: .leading) {
                Text("Next workout")
                    .customFont(size: 14, color: .white.opacity(0.3))
                Text(dateString.firstCapitalized)
                    .customFont(size: 18)


            }

        }
        .padding(.vertical, 5)

    }
}

#Preview {
    StreakDetailsNextWorkoutView(date: Calendar.current.date(byAdding: .day, value: 8, to: Date())!)
}







extension StringProtocol {
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

extension Date {
    var relativeDateString: String {
        let fromDate = Calendar.current.startOfDay(for: Date())
        let toDate = Calendar.current.startOfDay(for: self)
        let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day! // <3>
        
        if numberOfDays == 0 {
            return "today"
        }
        if numberOfDays == 1 {
            return "tomorrow"
        }
        if numberOfDays >= 2 && numberOfDays <= 7 {
            
            let dayOfWeekString = self.formatted(Date.FormatStyle().weekday(.wide))
           
            
            // Trying to make This and Next weekday clear
//            let dayOfWeekNow = Calendar.current.component(.weekday, from: Date())
//            let dayOfWeekThen = Calendar.current.component(.weekday, from: date)
//            let difference = dayOfWeekThen - dayOfWeekNow
            
//            var prefix = ""
            
            // if its the weekend... wierd shit happens with weekends
//            if dayOfWeekNow == 1 {
//                if dayOfWeekThen <= 4 {
//                    prefix = "this"
//                }
//            }
//            else if dayOfWeekNow == 7 {
//                // if wednesday or before say this, if after say next
//                if dayOfWeekThen <= 3 {
//                    prefix = "this"
//                }
//            } else if difference >= 0 || dayOfWeekThen == 1 {
//                prefix = "this"
//            }
            
            if numberOfDays == 7 {
                return "next \(dayOfWeekString)"
                
            }
            return dayOfWeekString
            
        } else if numberOfDays <= -2 && numberOfDays >= -7 {
            let dayOfWeek = self.formatted(Date.FormatStyle().weekday(.wide))
            return "last \(dayOfWeek)"
        }
        
        return self.formatted(.relative(presentation: .named))
    }
}
