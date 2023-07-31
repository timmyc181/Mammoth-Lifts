//

import SwiftUI

struct SetsRepsView: View {
    @Bindable var lift: Lift
    
    @State var sets: Int = 5
    @State var reps: Int = 5
    
    var body: some View {
        VStack(spacing: 40) {
            ListView {
                ListItemView {
                    Text("Sets")
                        .customFont(size: 20)
                    Spacer()
                    NumberStepper(value: $lift.targetSets, bounds: 1...8)
                }
                
                
                ListItemView(divider: false) {
                    Text("Reps")
                        .customFont(size: 20)
                    Spacer()
                    NumberStepper(value: $lift.targetReps, bounds: 1...8)
                }
            }
            
            ListView {
                ListItemView(divider: false) {
                    Text("Warmup sets")
                        .customFont(size: 20)
                    Spacer()
                    NumberStepper(value: $lift.warmupSets, bounds: 1...8)
                }
            }
            Spacer()
        }
        .padding(.horizontal, Constants.sheetPadding)
        .padding(.top, 40)
    }
    

}


struct SetsRepsItemView: View {
    var label: String
    @Binding var value: Int
    
    var body: some View {
        HStack {
            Text(label)
                .customFont(size: 20)
            Spacer()
            NumberStepper(value: $value, bounds: 1...8)
        }
        .padding(.vertical)
        .padding(.horizontal, 25)

        
    }
}


#Preview {
    ZStack {
        Color.sheetBackground.ignoresSafeArea()
        SetsRepsView(lift: .templateFor(.bench))

    }
}
