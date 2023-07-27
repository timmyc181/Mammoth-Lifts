//

import SwiftUI

struct ChooseLiftView: View {
    @Environment(AddLiftState.self) var addLiftState
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ScrollView {

            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Lift.Option.allCases, id: \.rawValue) { lift in
                    Button {
                        addLiftState.selectLift(lift: lift)
                    } label: {
                        ChooseLiftItemView(lift: lift)
                    }
                }
            }
        }
//        .padding(.top, 20)
//        .safeAreaPadding(.top)
//        .scrollClipDisabled()
        
        .safeAreaInset(edge: .top) {
            ZStack {
                LinearGradient(colors: [.sheetBackground, .clear], startPoint: .top, endPoint: .bottom)
//                LinearGradient(colors: [.sheetBackground, .clear], startPoint: .top, endPoint: .bottom)
            }
            .frame(height: 70)
        }
        .padding(.top, -60)

        .scrollIndicators(.hidden)
        .padding(.horizontal, Constants.sheetPadding)

    }
}

#Preview {
    ZStack {
        Color(.sheetBackground).ignoresSafeArea()
        AddLiftView()
            .environment(Navigation())
    }
}
