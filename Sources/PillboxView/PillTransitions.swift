//
//  PillTransitions.swift
//
//
//  Created by Jacob Trentini on 2/3/22.

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

import Foundation

extension PillView {
    
    /// Hides the ``PillboxView/PillView/pillView`` to the top of the screen.
    ///
    /// The ``PillboxView/PillView/pillView`` moves up to the top of the screen until it is out of sight.
    /// This is used within the ``PillboxView/PillView/completedTask(state:completionHandler:)`` and ``PillboxView/PillView/showError(message:vcView:)``.
    ///
    /// The animation, in total, takes 3 seconds to complete.
    ///
    /// This does not reset or de-initialize any values of the ``PillboxView/PillView``.
    ///
    /// - Parameters:
    ///   - animated: A Boolean indicating whether the ``PillboxView/PillView/pillView`` should be dismissed with an animation.
    ///   - timeBeforeMoveOut: Amount of time (in secs) before the ``PillboxView/PillView/pillView`` is moved outside the viewing frame
    ///   - completionHandler: A completion handler indicating when the animation has finished.
    public func dismiss(animated: Bool = true, timeBeforeMoveOut: TimeInterval = 1.5, completionHandler: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeBeforeMoveOut) {
            #if os(macOS)
            let originX = self.frame.origin.x
            let originY = self.vcView.frame.height /* Distance above top (plus value) */ + 50
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 1
                context.allowsImplicitAnimation = true
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                
                self.frame.origin = CGPoint(x: originX, y: originY)
            },
            completionHandler: {
                completionHandler?()
            })
            #else
            UIView.animate(withDuration: 1.0,
                           animations: {
                                // Only change the position of the origin Y axis to be above the container
                                self.frame.origin = CGPoint(x: self.frame.origin.x, y: 0 - self.frame.height)
                            },
                           completion: { completed in
                                if completed { completionHandler?() }
                           })
            #endif
        }
    }
    
    /// Reveal the ``PillboxView/PillView/pillView`` to the top of the screen.
    ///
    /// The ``PillboxView/PillView/pillView`` moves to the top of the screen until it is in sight (it usually comes from being dismissed).
    ///
    /// - Parameters:
    ///   - animated: A Boolean indicating whether the ``PillboxView/PillView/pillView`` should be revealed with an animation.
    ///   - completionHandler: A completion handler indicating when the animation has finished.
    public func reveal(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            #if os(macOS)
                NSAnimationContext.runAnimationGroup{ context in
                    context.duration = 0.25
                    context.allowsImplicitAnimation = true
                    context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                    
                    let originX = self.frame.origin.x
                    let originY = 25.0
                    self.frame.origin = CGPoint(x: originX, y: originY)
                }
            #else
            UIView.animate(withDuration: 1,
                            delay: 0.25,
                            animations: {
                                self.frame = CGRect(x: self.frame.minX,
                                                    y: UIDevice.current.hasNotch ? 45: 25 + (self.isNavigationControllerPresent ? 40 : 0),
                                                    width: self.frame.width,
                                                    height: self.frame.height)
                            },
                            completion: { completed in
                                if completed { completionHandler?() }
                            })
            #endif
        }
    }
}
