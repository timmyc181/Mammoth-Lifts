import SwiftUI




struct DatePickerContainerView: View {
    var value: DatePickerPreferenceKey.Value

    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                if let value {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture {
                            value.isPresented.wrappedValue = false
                        }
                        .zIndex(0)
                }
                if let value {
                    DatePickerView(date: value.date, position: value.position, geometry: geometry)
                        .zIndex(1)
                }
            }
            .animation(Constants.datePickerAnimation, value: value == nil)
        }
        .ignoresSafeArea()
    }
    

}

//struct PopoverContainerView<Content: View>: View {
//    @Binding var isPresented: Bool
//
//    @ViewBuilder var content: Content
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .bottom) {
//                if isPresented {
//                    Color.black.opacity(0.2)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            isPresented = false
//                        }
//                        .zIndex(0)
//                }
//                if isPresented {
//                    content
//                        .background(.regularMaterial)
//                        .clipShape(.rect(cornerRadius: 25))
//                        .position(x: geometry.size.width / 2, y: geometry[position].y - height / 2 - spacing)
//                        
//                        .transition(.scale(0, anchor: anchorPoint).combined(with: .opacity))
//                }
//            }
//            .animation(Constants.datePickerAnimation, value: isPresented)
//        }
//        .ignoresSafeArea()
//    }
//    
//
//}



struct DatePickerView: View {
    @Binding var date: Date
    var position: Anchor<CGPoint>
    var geometry: GeometryProxy
    
    private let width: CGFloat = 320
    private let height: CGFloat = 320
    private let padding: CGFloat = 20
    
    private var anchorPoint: UnitPoint {
        UnitPoint(x: geometry[position].x/geometry.size.width, y: (geometry[position].y - spacing) / geometry.size.height)
        
    }
    
    private let spacing: CGFloat = 10
    
    var body: some View {
        VStack {
            
            DatePicker("", selection: $date, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .frame(width: width, height: height)
                .shadow(radius: 20)
            
        }
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 25))
        .position(x: geometry.size.width / 2, y: geometry[position].y - height / 2 - spacing)
        
        .transition(.scale(0, anchor: anchorPoint).combined(with: .opacity))

    }
}

struct DatePickerTransitionModifier: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
    }
}

extension AnyTransition {
    static func datePicker(width: CGFloat, height: CGFloat) -> AnyTransition {
        modifier(
            active: DatePickerTransitionModifier(width: 0, height: 0),
            identity: DatePickerTransitionModifier(width: 200, height: 200)
        )
    }
}


struct DatePickerPreferenceKey: PreferenceKey {
    typealias Value = (date: Binding<Date>, isPresented: Binding<Bool>, position: Anchor<CGPoint>)?
    
    static var defaultValue: Value = nil
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        if let nextValue = nextValue(),
           nextValue.1.wrappedValue == true {
            value = nextValue
        }
    }
}

extension View {
    func datePicker(date: Binding<Date>, isPresented: Binding<Bool>) -> some View {
        anchorPreference(key: DatePickerPreferenceKey.self, value: .top) { position in
            (date: date, isPresented: isPresented, position: position)
        }
    }
}



fileprivate struct RandomPreview: View {
    @State var visible1: Bool = true
    @State var visible2: Bool = true
    @State var date = Date()
    
    @State private var navigation = Navigation()
    
    
    var body: some View {
        ZStack {
            HStack {
                GeometryReader { geo in
                    Button {
//                        navigation.datePicker = .init(frame: geo.frame(in: .global), date: $date)
                    } label: {
                        Text("Show")
                    }
                    .buttonStyle(.accentStretch)
                    .padding(.horizontal, 30)
                }
                .frame(height: ButtonStyleView.height)
                        
                        Button {
                            visible2 = true
                        } label: {
                            Text("Show")
                        }
                        .buttonStyle(.accentStretch)
                        .padding(.horizontal, 30)
                    }
            //            .zIndex(3)

//            .zIndex(4)

        }
        .environment(\.navigation, navigation)


    }
}

#Preview {
    RandomPreview()
}
