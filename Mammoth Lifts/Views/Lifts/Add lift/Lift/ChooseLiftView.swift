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
                    .scrollTransition { content, phase in
                        content.opacity(1 - phase.value)
                    }
                }
            }
            
        }
        .overlay(alignment: .top) {
            LinearGradient(colors: [.sheetBackground.opacity(0.9), .clear], startPoint: .top, endPoint: .bottom)
                                    .frame(height: 100)
                                    .padding(.top, -100)
                                    .allowsHitTesting(false)
        }
        .padding(.top, 30)
        .scrollClipDisabled()
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
