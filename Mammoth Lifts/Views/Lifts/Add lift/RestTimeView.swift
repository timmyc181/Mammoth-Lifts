//

import SwiftUI

struct RestTimeView: View {
    @State var minute: Int = 5
    @State var second: Int = 0
    
    var body: some View {
        VStack {
//            Text("\(minute ?? -1) minutes, \(second ?? -1) seconds")
//                .customFont()
            DurationPickerView(minute: $minute, second: $second)

        }
    }
}

#Preview {
    
    ZStack {
        Color(.background).ignoresSafeArea()
        RestTimeView()
    }
}
