import SwiftUI

struct LiftDetailsView: View {
    
    init(lift: Lift) {
        liftDetailsState = LiftDetailsState(lift: lift)
    }
    
    @State private var liftDetailsState: LiftDetailsState
    
    
    var body: some View {
        VStack(spacing: 20) {
            LiftDetailsHeaderView(name: liftDetailsState.lift.name)
                .padding(.top, 40)
            
            LiftDetailsActionsView(lift: liftDetailsState.lift)
                .padding(.top, 20)
            
            LiftDetailsBodyView(liftDetailsState: liftDetailsState)
        }
        .safeAreaPadding(.horizontal, Constants.sheetPadding)
        .overlay {
            WeightKeyboardOverlay(
                weight: liftDetailsState.focusState == .weight ? $liftDetailsState.lift.currentWeight : $liftDetailsState.lift.increment,
                visible: liftDetailsState.focusStateBinding,
                increment: liftDetailsState.focusState == .weight ? liftDetailsState.lift.increment : 0.25
            )
        }
        .animation(Constants.sheetPresentationAnimation, value: liftDetailsState.focusState)
//        .border(Color.red)
    }
}



@Observable class LiftDetailsState {
    var lift: Lift
    
    var focusState: LiftDetailsFocusState? = nil
    var focusStateBinding: Binding<Bool> {
        Binding {
            return self.focusState != nil
        } set: { newVal in
            if !newVal {
                self.focusState = nil
            }
        }
    }

    
    init(lift: Lift) {
        self.lift = lift
    }
    
    
    enum LiftDetailsFocusState {
        case weight
        case increment
    }
}


#Preview {
    DumbPreviewThing {
        LiftDetailsView(lift: .template(for: .squat))
    }
}
