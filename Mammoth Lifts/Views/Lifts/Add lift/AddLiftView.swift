import SwiftUI
import Observation

struct AddLiftView: View {
    @Environment(\.navigation) private var navigation
    
    @State var addLiftState: AddLiftState

    init(addLiftState: AddLiftState = AddLiftState()) {
        self.addLiftState = addLiftState
    }
    
    var body: some View {
        VStack {
            AddLiftHeaderView(progress: addLiftState.progress)
                .safeAreaPadding(.horizontal, Constants.sheetPadding)

            AddLiftTitle(state: addLiftState.state)
                .padding(.top, 30)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: addLiftState.movingForwards ? .trailing : .leading),
                        removal: .move(edge: addLiftState.movingForwards ? .leading : .trailing))
                )
                .zIndex(1)
                .safeAreaPadding(.horizontal, Constants.sheetPadding)
            
            VStack(spacing: 0) {

                Spacer(minLength: 0)

                Group {
                    switch addLiftState.state {
                    case .lift:
                        ChooseLiftView(selectedLift: $addLiftState.lift)
                    case .weight:
                        ChooseWeightView(lift: addLiftState.lift!)
                    case .setsReps:
                        SetsRepsView(lift: addLiftState.lift!)
                    case .rest:
                        @Bindable var lift = addLiftState.lift!
                        RestTimeView(minutes: $lift.restTimeMinutes, seconds: $lift.restTimeSeconds)
                    case .increment:
                        Text("Increment")
                            .customFont()
                            .frame(maxWidth: .infinity)
                    }
                }
                .safeAreaPadding(.horizontal, Constants.sheetPadding)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: addLiftState.movingForwards ? .trailing : .leading),
                        removal: .move(edge: addLiftState.movingForwards ? .leading : .trailing))
                )

                
                if addLiftState.state != .lift {
                    Spacer(minLength: 0)
                }
            }
            
            // To disable the sheet gesture when interacting with the content
            .contentShape(Rectangle())

            
            if addLiftState.state != .lift {
                AddLiftFooterView()
                    .transition(
                        .asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top))
                    )
                    .safeAreaPadding(.horizontal, Constants.sheetPadding)
            }
            
        }
        .animation(.smooth(duration: 0.3), value: addLiftState.state)
        .onChange(of: addLiftState.movingForwards) { _, newValue in
            if newValue {
                addLiftState.state += 1
            } else {
                addLiftState.state -= 1
            }
        }
        .environment(\.addLiftState, addLiftState)
    }
}

struct AddLiftPreviewView: View {
    var state: AddLiftState.State
    var lift: Lift.Option
    
    init(state: AddLiftState.State = .lift, lift: Lift.Option = .bench) {
        self.state = state
        self.lift = lift
    }
    
    private var addLiftState = AddLiftState()
    
    
    var body: some View {
        AddLiftView(addLiftState: addLiftState)
            .onAppear {
                addLiftState.lift = .template(for: lift)
                addLiftState.state = state
            }
            .emptyPreviewContainer()
            .background {
                Color.sheetBackground
                    .ignoresSafeArea()
            }
    }
}


#Preview {
    AddLiftPreviewView(state: .rest)
//
//    ContentView()
//        .populatedPreviewContainer()
}






struct NoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

extension View {
    func sheetGestureOverride() -> some View {
        // To override the sheet gesture
        background {
            Button {} label: {
                Color.clear.contentShape(Rectangle())
            }
            .buttonStyle(NoButtonStyle())
        }
    }
}
