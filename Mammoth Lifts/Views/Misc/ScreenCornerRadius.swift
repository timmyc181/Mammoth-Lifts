//
//  ScreenCornerRadius.swift
//  Mammoth Lifts
//
//  Created by Timothy Cleveland on 7/15/23.
//

import Foundation


import UIKit
import SwiftUI

extension UIScreen {
    private static let cornerRadiusKey: String = {
        let components = ["Radius", "Corner", "display", "_"]
        return components.reversed().joined()
    }()

    /// The corner radius of the display. Uses a private property of `UIScreen`,
    /// and may report 0 if the API changes.
    public var displayCornerRadius: CGFloat {
        guard let cornerRadius = self.value(forKey: Self.cornerRadiusKey) as? CGFloat else {
            assertionFailure("Failed to detect screen corner radius")
            return 0
        }

        return cornerRadius
    }
}

struct ScreenRectangle: View {
    var fill: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: UIScreen.main.displayCornerRadius, style: .continuous)
            .fill(fill)
    }
}
