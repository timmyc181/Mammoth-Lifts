import SwiftUI
import Observation

struct AddLiftView: View {
    @Environment(Navigation.self) var navigation
    
    @State var addLiftState = AddLiftState()
    
    var body: some View {
        VStack {
            AddLiftHeaderView(progress: addLiftState.progress)
                .padding(.top, 20)
                .padding(.horizontal, Constants.sheetPadding)

            AddLiftTitle(state: addLiftState.state)
                .padding(.top, 30)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: addLiftState.movingForwards ? .trailing : .leading),
                        removal: .move(edge: addLiftState.movingForwards ? .leading : .trailing))
                )
                .zIndex(1)

            Spacer()
            Group {
                switch addLiftState.state {
                case .lift:
                    ChooseLiftView()
                case .weight:
                    ChooseWeightView()
                case .setsReps:
                    SetsRepsView(lift: addLiftState.lift!)
//                    Spacer()
                case .rest:
                    RestTimeView()
                        .customFont()
                        .frame(maxWidth: .infinity)
                case .increment:
                    Text("Increment")
                        .customFont()
                        .frame(maxWidth: .infinity)
                }
            }
            .transition(
                .asymmetric(
                    insertion: .move(edge: addLiftState.movingForwards ? .trailing : .leading),
                    removal: .move(edge: addLiftState.movingForwards ? .leading : .trailing))
            )
            
            if addLiftState.state != .lift {
                Spacer(minLength: 0)
                AddLiftFooterView()
                    .transition(
                        .asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top))
                    )
            }
            
        }
        .animation(.snappy(duration: 0.3), value: addLiftState.state)
        .onChange(of: addLiftState.movingForwards) { _, newValue in
            if newValue {
                addLiftState.state += 1
            } else {
                addLiftState.state -= 1
            }
        }
        .environment(addLiftState)
        .onChange(of: addLiftState.state) { oldValue, newValue in
            if newValue == .weight || newValue == .rest || newValue == .lift {
                navigation.sheetGestureEnabled = false
            } else {
                navigation.sheetGestureEnabled = true
            }
        }
        .onAppear {
            navigation.sheetGestureEnabled = false
        }
    }
}





@Observable class AddLiftState {
    var state: State = .lift
    var lift: Lift? = nil
    
    var movingForwards: Bool = true
    
    var progress: Double {
        Double(state.rawValue) / 6
    }
    
    enum State: Int {
        case lift = 1
        case weight = 2
        case setsReps = 3
        case rest = 4
        case increment = 5
        
        
        static func -=(_ x: inout State, _ y: Int){
            x = State(rawValue: x.rawValue - y) ?? .lift
        }
        
        static func +=(_ x: inout State, _ y: Int) {
            x = State(rawValue: x.rawValue + y) ?? .lift
        }
    }
    
    func selectLift(lift: Lift.Option) {
        self.lift = Lift.templateFor(lift)
        next()
    }
    
    func next() {
        if movingForwards {
            state = State(rawValue: state.rawValue + 1) ?? .rest

        } else {
            movingForwards = true
        }
    }
    
    func previous() {
        if !movingForwards {
            state = State(rawValue: state.rawValue - 1) ?? .rest

        } else {
            movingForwards = false
        }
    }
    
}

#Preview {
    AddLiftView()
        .environment(Navigation())
        .background {
            Color.sheetBackground
                .ignoresSafeArea()
        }
}
