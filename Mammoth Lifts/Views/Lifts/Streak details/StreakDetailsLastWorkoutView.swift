//

import SwiftUI

struct StreakDetailsLastWorkoutView: View {
    var workout: Workout
    
    var dateString: String {
        workout.date.startOfDay.formatted(.relative(presentation: .named))
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Last workout")
                    .customFont(size: 14)
                    .opacity(0.3)
                Text(dateString.firstCapitalized)
                    .customFont(size: 14)
            }
            Spacer()
            Image("\(workout.lift?.name ?? "error") icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color.accentColor)
                .frame(height: 24)
//                                .offset(y: 8)

//                                    .padding(.trailing, 10)
            Text(workout.lift?.name ?? "Error")
                .customFont(size: 16)
                .opacity(0.3)

//                        Text("Friday")
//                            .opacity(0.3)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 12)
        .background {
            Color.black
                .opacity(0.25)
                
//                        .cornerRadius(10)
//                                .padding(.horizontal)
//                                .padding(.vertical, 5)
        }
    }
}

//#Preview {
//    StreakDetailsLastWorkoutView()
//}
