//
//  PillboxColors.swift
//  PillboxView
//
//  Created by Jacob Trentini on 1/2/22.
//

import Foundation

internal extension UIColor {
    static var PillboxBackgroundColor: UIColor {
        return UIColor { (traits) -> UIColor in
            // Return one of two colors depending on light or dark mode
            return traits.userInterfaceStyle == .light ?
                .white : UIColor(red: 0.12941176, green: 0.12156863, blue: 0.10588235, alpha: 1)
        }
    }
    
    static var PillboxTitleColor: UIColor {
        return UIColor(displayP3Red: 0.54117647, green: 0.5372549, blue: 0.55294118, alpha: 1)
    }
}
