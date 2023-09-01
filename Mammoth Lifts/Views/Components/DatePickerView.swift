//

import SwiftUI

struct DatePickerContainerView: View {
    @Environment(\.navigation) private var navigation

    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if navigation.datePicker != nil {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture {
                            navigation.datePicker = nil
                        }
                        .zIndex(0)
                }
                Group {
                    if let datePicker = navigation.datePicker {
                        DatePickerView(date: datePicker.date, position: datePicker.position, screen: geo.size)
                            .zIndex(1)

                    }
                }

            }
            .animation(Constants.datePickerAnimation, value: navigation.datePicker == nil)
        }
        .ignoresSafeArea()
    }
    

}


struct DatePickerView: View {
    @Binding var date: Date
    var position: CGPoint
    var screen: CGSize
    
    var width: CGFloat = 300
    var height: CGFloat = 300
    var padding: CGFloat = 20
    
    private var yOffset: CGFloat {
        let anchoredToBottom = position.y - height/2
        let minPos = 0 + height/2 + padding
        let maxPos = screen.height - height/2 - padding
        let yPosition = max(min(anchoredToBottom, maxPos), minPos)
        print(position.y / screen.height)
        return yPosition - screen.height/2
    }
    
    var body: some View {
        DatePicker("", selection: $date, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .frame(width: width, height: height)
            .padding()
            .background(.thickMaterial)
            .mask {
                RoundedRectangle(cornerRadius: 25)
            }
            .shadow(radius: 20)
            .offset(y: yOffset)
//            .position(x: screen.width/2, y: 0)

//        }
            .transition(.scale(0, anchor: .init(x: position.x/screen.width, y: (height+yOffset)/height)).combined(with: .opacity))

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
                        navigation.datePicker = .init(frame: geo.frame(in: .global), date: $date)
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
            DatePickerContainerView()
            //            .zIndex(3)

//            .zIndex(4)

        }
        .environment(\.navigation, navigation)


    }
}

#Preview {
    RandomPreview()
}
