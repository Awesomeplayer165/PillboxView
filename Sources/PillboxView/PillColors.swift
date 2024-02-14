//
//  PillColors.swift
//  PillboxView
//
//  Created by Jacob Trentini on 1/2/22.

import NSUI
#if canImport(AppKit)
import AppKit
#endif

internal extension NSUIColor {
    #if os(macOS)
    @available(OSX 10.14, *)
    static var isLightModeOn: Bool { NSApp.effectiveAppearance.name == NSAppearance.Name.aqua }
    
    @available(OSX 10.14, *)
    static var isDarkModeOn: Bool { NSApp.effectiveAppearance.name == NSAppearance.Name.darkAqua }
    #endif
    
    static var PillboxBackgroundColor: NSUIColor {
        #if os(macOS)
        if NSUIColor.isLightModeOn {
            return NSUIColor.white
        }
        else {
            return NSUIColor.lightGray
        }
        #else
        return NSUIColor { (traits) -> NSUIColor in
            // Return one of two colors depending on light or dark mode
            
            #if targetEnvironment(macCatalyst)
                return traits.userInterfaceStyle == .light ?
                .white : NSUIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1)
            #else
                return traits.userInterfaceStyle == .light ?
                .white : NSUIColor(red: 0.12941176, green: 0.12156863, blue: 0.10588235, alpha: 1)
            #endif
        }
        #endif
    }
    
    static var PillboxTitleColor: NSUIColor {
        #if os(macOS)
        if NSUIColor.isLightModeOn {
            return NSUIColor.darkGray
        }
        else {
            return NSUIColor.white
        }
        #else
        return NSUIColor(displayP3Red: 0.54117647, green: 0.5372549, blue: 0.55294118, alpha: 1)
        #endif
    }
}
