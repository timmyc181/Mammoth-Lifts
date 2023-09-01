//
//  Fonts.swift
//  Mammoth 5x5
//
//  Created by Timothy Cleveland on 1/18/22.
//

import SwiftUI

struct Fonts_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            Text("hi")
                .customFont()

        }
    }
}

public enum FontStyle {
    case heading
    case subtitle1
    case subtitle2
    case button
    case list
}

fileprivate struct CommonFontFuncs {
    static func getFontSize(_ style: FontStyle) -> CGFloat {
        switch style {
        case .heading: return 36
        case .subtitle1: return 24
        case .subtitle2: return 20
        case .button: return 20
        case .list: return 18
        }
    }

}

//extension Text {
//    public func customFont(_ fontStyle: FontStyle? = nil, size: CGFloat? = nil, color: Color? = .white) -> Text {
//        var finalSize: CGFloat
//        if let unwrappedFontStyle = fontStyle {
//            finalSize = CommonFontFuncs.getFontSize(unwrappedFontStyle)
//        } else {
//            finalSize = CommonFontFuncs.getFontSize(.subtitle2)
//        }
//        if let unwrappedSize = size {
//            finalSize = unwrappedSize
//        }
//        
//        return self
//            .font(Font.custom("CaustenRound-ExtraBold", size: finalSize))
//            .foregroundColor(color)
//    }
//    
//}

extension View {
    
    public func customFont(_ fontStyle: FontStyle? = nil, size: CGFloat? = nil, color: Color? = .white) -> some View {
        var finalSize: CGFloat
        if let unwrappedFontStyle = fontStyle {
            finalSize = CommonFontFuncs.getFontSize(unwrappedFontStyle)
        } else {
            finalSize = CommonFontFuncs.getFontSize(.subtitle2)
        }
        if let unwrappedSize = size {
            finalSize = unwrappedSize
        }
        
        return self
            .font(Font.custom("CaustenRound-ExtraBold", size: finalSize))
            .foregroundColor(color)
            .offset(y: -finalSize/25.0)
    }
}
