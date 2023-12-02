import SwiftUI

struct StreakDetailsCalendarView: View {
    @Environment(\.streak) private var streak
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 15) {
                CalendarItemView(day: "Wed", streakActive: false) {
//                    Text("22")
//                        .customFont(color: Color(.streaks))
//                        .opacity(0.6)
                }
                CalendarItemView(day: "Thu", streakActive: false) {
//                    Text("23")
//                        .customFont(color: Color(.streaks))
//                        .opacity(0.6)
                }
                HStack(spacing: 25) {
                    CalendarItemView(day: "Fri", workout: true) {
                        Image(systemName: "flame.fill")
//                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.streaks))
                    }
                    CalendarItemView(day: "Sat") {
//                        Text("Sa")
//                            .customFont(color: Color(.streaks))
//                            .opacity(0.6)
                    }
                    CalendarItemView(day: "Sun", today: true) {
//                        Text("Su")
//                            .customFont(color: Color(.streaks))
//                            .opacity(1)
                    }
                }
                .background {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(.streaks))
                            .opacity(0.15)
                            .padding(.vertical, 5)
                            .padding(.leading, 5)
                        Circle()
                            .frame(width: 40, height: 40)
                            .scaleEffect(1.2)
                            .blendMode(.destinationOut)
                    }
                    .compositingGroup()
                    .padding(.bottom, 24.5)



                }
//                .padding(10)
//                .overlay {
//                    Capsule()
//                        .fill(Color(.streaks))
//                        .opacity(0.15)
//                }
                
                CalendarItemView(day: "Mon", flag: true, streakActive: false) {
                    Image(systemName: "flag.fill")
                        .foregroundColor(Color(.accent))
                }
                CalendarItemView(day: "Tue", streakActive: false) {
//                    Image(systemName: "flag.fill")
//                        .foregroundColor(Color(.streaks))
                }
                CalendarItemView(day: "Wed", streakActive: false) {
//                    Image(systemName: "flag.fill")
//                        .foregroundColor(Color(.streaks))
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        
    }
    
}

fileprivate struct CalendarItemView<Content: View>: View {
    var day: String
    var workout: Bool = false
    var flag: Bool = false
    var streakActive: Bool = true
    var today: Bool = false
    
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            Group {
                
                if streakActive {
                    if workout {
                        Circle()
                        //                .stroke(.white.opacity(0.1), lineWidth: 4)
                            .fill(Color(.streaks).opacity(workout ? 0.15 : 0))

                    } else {
                        Circle()
                        //                .stroke(.white.opacity(0.1), lineWidth: 4)
                            .fill(.white.opacity(0))
                            .overlay {
//                                Circle()
//                                    .fill(.white.opacity(0.2))
//                                    .frame(width: 15, height: 15)
//                                Text("25")
//                                    .customFont(size: 16)
//                                    .opacity(0.3)
                            }
                    }

                } else {
                    if flag {
                        Circle()
                            .strokeBorder(.white.opacity(0.1), lineWidth: 4)
//                            .fill(.white.opacity(0.1))
//                            .padding(5)
    //                        .stroke(.white.opacity(0.1), lineWidth: 2)
                    } else {
                        Circle()
    //                        .strokeBorder(.white.opacity(0.1), lineWidth: 4)
                            .fill(.white.opacity(0.1))
                            .padding(5)
    //                        .stroke(.white.opacity(0.1), lineWidth: 2)
                    }

                }
            }

//                .fill(.white.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay {
                    content
                }
            Text(day)
                .customFont(size: 16)
                .opacity(today ? 1 : 0.3)
                .background(alignment: .bottom) {
                    if workout {
                        Triangle()
                            .stroke(style: StrokeStyle(lineWidth: 8, lineJoin: .round))
                            .foregroundColor(Color(.listBackground))
//                            .fill(Color(.listBackground))
                            .frame(width: 20, height: 10)
                            .offset(y: 24)
    //                                    .cornerRadius(10)
                    }

                }
        }


    }
//    var body: some View {
//        Text(day)
//            .customFont(size: 20, color: streakActive ? .white : .black)
//            .opacity(streakActive ? today ? 1 : 0.3 : 1)
//            .background {
//                if !streakActive {
//                    Image(systemName: "flag.fill")
//                        .foregroundColor(Color(.streaks))
//                        .font(.system(size: 36))
//                        .offset(y: 5)
////                        .frame(width: 50, height: 50)
//                }
//            }
////        VStack {
////            Group {
////                
////                if streakActive {
////                    Circle()
////                    //                .stroke(.white.opacity(0.1), lineWidth: 4)
////                        .fill(Color(.streaks).opacity(0.1))
////                } else {
////                    Circle()
////                        .stroke(.white.opacity(0.1), lineWidth: 2)
////                    //                    .fill(Color(.streaks).opacity(0.1))
////                }
////            }
////
//////                .fill(.white.opacity(0.1))
////                .frame(width: 40, height: 40)
////                .overlay {
////                    content
////                }
////
////        }
//
//
//    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.closeSubpath()

        return path
    }
}

#Preview {
    StreakDetailsCalendarView()
}
