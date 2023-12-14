//
//  UXView+Extensions.swift
//  
//
//  Created by Martin Dufort on 2023-12-13.
//

import UXKit
import Foundation

extension UXView {

    /// Return the origin `UXPoint` for a view which needs to be centered horizontally within its superview
    /// This is performed with frame math only and it is set at init type.
    /// Changing the window size will not recalculate the origin.
    public func originForCenter(inRelationTo parentView: UXView) -> UXPoint {
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
        return UXPoint(x: newOriginX, y: newOriginY)
    }    
}

extension UXImageView {
    #if os(macOS)
    public var tintColor: UXColor? {
        @available(*, unavailable)
        get { fatalError("You can only set the tintColor") }

        set {
            guard
                let selfImage = self.image,
                let newColor = newValue
            else { return }
            
            let image = UXImage(size: selfImage.size, flipped: false) { rect -> Bool in
                newColor.set()
                rect.fill()
                selfImage.draw(in: rect, from: NSRect(origin: .zero, size: selfImage.size), operation: .destinationIn, fraction: 1.0)
                return true
            }
            self.image = image
        }
    }
    #endif
}
