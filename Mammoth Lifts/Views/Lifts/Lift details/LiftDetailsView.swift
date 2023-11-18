import SwiftUI

struct LiftDetailsView: View {
    var lift: Lift
    
    var body: some View {
        GeometryReader { geo in
                VStack(spacing: 20) {
                    LiftDetailsHeaderView(name: lift.name)
                        .padding(.top, 40)
                    
                    LiftDetailsActionsView(lift: lift)
                        .padding(.top, 20)
                    
                    LiftDetailsBodyView(lift: lift)
                        
                }
                .safeAreaPadding(.horizontal, Constants.sheetPadding)
        }
        
    }
}


#Preview {
    DumbPreviewThing {
        LiftDetailsView(lift: .template(for: .squat))
    }
}
