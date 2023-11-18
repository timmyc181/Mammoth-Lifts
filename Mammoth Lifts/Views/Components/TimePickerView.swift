import SwiftUI

struct TimePickerContainerView: View {
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
                    TimePickerView(date: value.date, position: value.position, geometry: geometry)
                        .zIndex(1)
                }
            }
            .animation(Constants.datePickerAnimation, value: value == nil)
        }
        .ignoresSafeArea()
    }
    

}


struct TimePickerView: View {
    @Binding var date: Date
    var position: Anchor<CGPoint>
    var geometry: GeometryProxy
    
    private let width: CGFloat = 320
    private let height: CGFloat = 230
    private let padding: CGFloat = 20
    
    private var anchorPoint: UnitPoint {
        UnitPoint(x: geometry[position].x/geometry.size.width, y: (geometry[position].y - spacing) / geometry.size.height)
        
    }
    
    private let spacing: CGFloat = 10
    
    var body: some View {
        VStack(alignment: .center) {
            
            DatePicker("", selection: $date, in: ...Date(), displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .padding()
                .border(Color.red)
            
        }
        .frame(width: width, height: height)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 25))
        .shadow(radius: 20)
        .position(x: geometry.size.width / 2, y: geometry[position].y - height / 2 - spacing)
        
        .transition(.scale(0, anchor: anchorPoint).combined(with: .opacity))

    }
}

struct TimePickerPreferenceKey: PreferenceKey {
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
    func timePicker(date: Binding<Date>, isPresented: Binding<Bool>) -> some View {
        anchorPreference(key: TimePickerPreferenceKey.self, value: .top) { position in
            (date: date, isPresented: isPresented, position: position)
        }
    }
}
