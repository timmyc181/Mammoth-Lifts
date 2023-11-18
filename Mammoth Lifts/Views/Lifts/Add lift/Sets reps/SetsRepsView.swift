//

import SwiftUI

struct SetsRepsView: View {
    @Bindable var lift: Lift
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            SetsRepsPickerView(sets: $lift.targetSets, reps: $lift.targetReps)
                .frame(height: 300)
            Spacer()
            
//            ListView {
//                ListItemView(divider: false) {
//                    Text("Warmup sets")
//                        .customFont(size: 20)
//                    Spacer()
//                    NumberStepper(value: $lift.warmupSets, bounds: Constants.setsRange)
//                }
//            }
        }
        .padding(.bottom, 30)
    }
    

}


#Preview {
    AddLiftPreviewView(state: .setsReps)
}
