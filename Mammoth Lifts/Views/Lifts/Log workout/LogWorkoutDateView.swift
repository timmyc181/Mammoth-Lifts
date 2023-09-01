//

import SwiftUI

struct LogWorkoutDateView: View {
    @Binding var date: Date
    
    @Environment(\.navigation) private var navigation
    
    private var dateString: String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        // Only include year if year is different
        if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year) {
            return date.formatted(.dateTime.day().month())
        }
        
        return date.formatted(.dateTime.day().month().year())

    }
    
    private var timeString: String {
        date.formatted(date: .omitted, time: .shortened).lowercased()
    }
    
    @State private var dateVisible: Bool = false
    @State private var timeVisible: Bool = false
    
    private let height: CGFloat = 45
    
    var body: some View {
        HStack(spacing: 20) {
            GeometryReader { geo in
                Button {
                    navigation.datePicker = .init(frame: geo.frame(in: .global), date: $date)
                } label: {
                    Text(dateString)
                        .customFont(color: .accentColor)
                }
                .buttonStyle(EditLiftActionsButtonStyle(height: height))
            }
            
            
            GeometryReader { geo in
                Button {
                    navigation.datePicker = .init(frame: geo.frame(in: .global), date: $date)
                } label: {
                    Text(timeString)
                        .customFont(color: .accentColor)
                }
            .buttonStyle(EditLiftActionsButtonStyle(height: height))
            }

//            Rectangle()
//                .fill(Color.accentColor.opacity(0.5))
//                .frame(width: 150, height: 50)
//                .overlay {
//                    DatePicker("date", selection: $date, displayedComponents: .date)
//                        .environment(\.colorScheme, .dark)
//                        .overlay {
//                            Color.red
//                                .allowsHitTesting(false)
//                        }
//                        .blendMode(.destinationOver)
////                        .opacity(0.1)
//                        .allowsHitTesting(true)
//                }
//            
//            DatePicker("date", selection: $date, displayedComponents: .date)
//            DatePicker(selection: $date) {
//                Text("sadf")
//            }
//            DatePickerStyleConfiguration
//            .datePickerStyle(.)
//            DatePickerStyle
        }
        .frame(height: height)
    }
}

#Preview {
    LogWorkoutDateView(date: .constant(Date()))
}
