//
//  PillColors.swift
//  PillboxView
//
//  Created by Jacob Trentini on 1/2/22.

import UXKit
#if canImport(AppKit)
import AppKit
#endif

internal extension UXColor {
    #if os(macOS)
    @available(OSX 10.14, *)
    static var isLight: Bool { NSApp.effectiveAppearance.name == NSAppearance.Name.aqua }
    
    @available(OSX 10.14, *)
    static var isDark: Bool { NSApp.effectiveAppearance.name == NSAppearance.Name.darkAqua }
    #endif
    
    static var PillboxBackgroundColor: UXColor {
        #if os(macOS)
        if UXColor.isLight {
            return UXColor.white
        }
        else {
            return UXColor.lightGray
        }
        #else
        return UXColor { (traits) -> UXColor in
            // Return one of two colors depending on light or dark mode
            
            #if targetEnvironment(macCatalyst)
                return traits.userInterfaceStyle == .light ?
                .white : UXColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1)
            #else
                return traits.userInterfaceStyle == .light ?
                .white : UXColor(red: 0.12941176, green: 0.12156863, blue: 0.10588235, alpha: 1)
            #endif
        }
        #endif
    }
    
    static var PillboxTitleColor: UXColor {
        #if os(macOS)
        if UXColor.isLight {
            return UXColor.black
        }
        else {
            return UXColor.white
        }
        #else
        return UXColor(displayP3Red: 0.54117647, green: 0.5372549, blue: 0.55294118, alpha: 1)
        #endif
    }
}
