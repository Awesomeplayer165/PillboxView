//
//  NSUI+Extensions.swift
//  
//

import Foundation

// ---
import NSUI

internal extension NSUIView {

    /// Return the origin `UXPoint` for a view which needs to be centered horizontally within its superview
    /// This is performed with frame math only and it is set at init type.
    /// Changing the window size will not recalculate the origin.
    func originForCenter(inRelationTo parentView: NSUIView) -> CGPoint {
        guard
            parentView.frame != NSZeroRect
        else {
            fatalError("Your parentView must have a non-zero size")
        }
        
        let midPoint = NSMidX(parentView.frame)
        
        // Now get the half the width of our view and substract than from the midPoint
        let selfMidPoint = self.frame.width / 2
        
        let newOriginX = (midPoint - selfMidPoint).rounded()
        let newOriginY = self.frame.origin.y
        return CGPoint(x: newOriginX, y: newOriginY)
    }    
}

#if canImport(AppKit)
import AppKit
#endif

internal extension NSUIColor {
    #if os(macOS)
    @available(OSX 10.14, *)
    static var isLight: Bool { NSApp.effectiveAppearance.name == NSAppearance.Name.aqua }
    
    @available(OSX 10.14, *)
    static var isDark: Bool { NSApp.effectiveAppearance.name == NSAppearance.Name.darkAqua }
    #endif
}

