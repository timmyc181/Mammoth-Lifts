import SwiftUI
import SwiftData

struct AddLiftFooterView: View {
    @Environment(\.addLiftState) private var addLiftState
    @Environment(\.modelContext) private var modelContext
    @Environment(\.navigation) private var navigation

    var body: some View {
        HStack {
            Button {
                addLiftState.previous()
            } label: {
                Image(.chevronIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .scaleEffect(x: -1)
                    .offset(x: -2)
            }
            .buttonStyle(.secondary)
            Spacer()
            Button {
                if addLiftState.state == .increment {
                    // Add lift
                    guard let lift = addLiftState.lift else {
                        fatalError("No lift to add...")
                    }
                    
                    modelContext.insert(lift)
                    
                    do {
                        try modelContext.save()
                    } catch {
                        fatalError("Error deleting lift")
                    }
                    
                    navigation.addLiftPresented = false
                } else {
                    addLiftState.next()
                }
            } label: {
                Text(addLiftState.state == .increment ? "Done" : "Next")
                    .padding(.horizontal, 30)
                    .offset(y: -1)
            }
            .buttonStyle(.accent)
            

        }
    }
}

//#Preview {
//    AddLiftFooderView()
//}
