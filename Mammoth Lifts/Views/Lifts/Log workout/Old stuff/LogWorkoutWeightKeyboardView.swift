//

import SwiftUI

struct LogWorkoutWeightKeyboardView: View {
    @Bindable var logWorkoutState: LogWorkoutState
    
    var body: some View {
        GeometryReader { geo in
//            VStack {
//                Spacer()
//                if logWorkoutState.weightFocused {
//                    HStack {
////                        WeightKeyboard(weight: $logWorkoutState.workoutDetails.weight, controls: .all($logWorkoutState.weightFocused), increment: logWorkoutState.lift.increment)
//                        
//                    }
//                    .safeAreaPadding(.horizontal, Constants.sheetPadding)
//                    .padding(.bottom, geo.safeAreaInsets.bottom)
//                    .padding(.top, 30)
//                    .background {
//                        Color(.smallSheetBackground)
//                    }
//                    .offset(y: geo.safeAreaInsets.bottom + 10)
//
//                    .shadow(radius: 10)
//                
//                    .transition(.move(edge: .bottom))
//                }
//                
//            }
//            .background {
////                if logWorkoutState.weightFocused {
//                    Color.clear
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            logWorkoutState.weightFocused = false
//                        }
//                        .allowsHitTesting(logWorkoutState.weightFocused)
////                }
//            }
        }
        

    }
}

//struct LogWorkout


//#Preview {
//    LogWorkoutWeightKeyboardView()
//}
