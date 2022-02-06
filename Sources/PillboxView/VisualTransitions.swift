//
//  File.swift
//  
//
//  Created by Jacob Trentini on 2/3/22.
//

import UIKit

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
    ///   - completionHandler: A completion handler indicating when the animation has finished.
    open func dismiss(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 1, delay: 0.25) {
                self.pillView.frame = CGRect(x: self.pillView.frame.minX,
                                             y: -300,
                                             width: self.pillView.frame.width,
                                             height: self.pillView.frame.height)
                
                if let completionHandler = completionHandler { completionHandler() }
            }
        }
    }
    
    /// Hides the ``PillboxView/PillView/pillView`` to the top of the screen.
    ///
    /// The ``PillboxView/PillView/pillView`` moves to the top of the screen until it is in sight (it usually comes from being dismissed).
    ///
    /// - Parameters:
    ///   - animated: A Boolean indicating whether the ``PillboxView/PillView/pillView`` should be revealed with an animation.
    ///   - completionHandler: A completion handler indicating when the animation has finished.
    open func reveal(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 1, delay: 0.25) {
                self.pillView.frame = CGRect(x: self.pillView.frame.minX,
                                             y: UIDevice.current.hasNotch ? 45: 25 + (self.isNavigationControllerPresent ? 40 : 0),
                                             width: self.pillView.frame.width,
                                             height: self.pillView.frame.height)
                
                if let completionHandler = completionHandler { completionHandler() }
            }
        }
    }
}
