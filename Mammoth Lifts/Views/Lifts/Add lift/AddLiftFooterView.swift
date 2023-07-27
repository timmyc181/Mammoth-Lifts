import SwiftUI

struct AddLiftFooterView: View {
    @Environment(AddLiftState.self) var addLiftState
    
    var body: some View {
        HStack {
            RegularButton(type: .secondary, stretch: false) {
                addLiftState.previous()
            } label: {
                Image("ChevronIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .scaleEffect(x: -1)
                    .offset(x: -2)
            }
            Spacer()
            RegularButton(type: .accent, stretch: false) {
                addLiftState.next()
            } label: {
                Text("Next")
                    .padding(.horizontal, 30)
                    .offset(y: -1)
            }
            

        }
        .padding(.horizontal, Constants.sheetPadding)
        .padding(.bottom, 30)
    }
}

//#Preview {
//    AddLiftFooderView()
//}
