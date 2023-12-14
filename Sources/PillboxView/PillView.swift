//
//  PillView.swift
//  PillboxView
//
//  Created by Jacob Trentini on 12/30/21.
//  macOS Compatibility (via NSUI) added by Martin Dufort on 12/12/23

import CoreGraphics
import Foundation

#if canImport(AppKit)
import AppKit
#endif

// ---
import UXKit     // To unify AppKit and UIKit and add macOS compatibility


/// A `UIView` to display two forms of dynamic content based on the conditions or needs of a developer.
public class PillView: UXView {
    /// The `UXView` itself that holds the content of the ``PillboxView/PillView``, such as a title and imageView.
    ///
    ///  This shows information based on the ``PillboxView/PillShowType``.
    ///  Both causes hold a title/message `NSUILabel` and a  `NSUIImageView`, customizable to the developer's suitable needs.
    // public var pillView = UXView()

    /// The width of the ``PillboxView/PillView/pillView``.
    public var width = 400
    
    /// The height of the ``PillboxView/PillView/pillView``.
    ///
    /// If a `UINavigationController` obstructs it, then set ``PillboxView/PillView/isNavigationControllerPresent`` to `true`
    public var height = 35
    
    /// A `UXSpinner` aka `NSUIActivityIndicatorView` in UIKIt for the asynchronous task of the ``PillboxView/PillShowType/ongoingTask``.
    ///
    /// This should not be used if using ``PillboxView/PillShowType/error``
    public private(set) var activityIndicator = UXSpinner()
    
    /// A `UXLabel` align on the ``PillboxView/PillView/pillView``'s center-left to display a message.
    ///
    /// The message should not be set through accessing the properties of this label, but rather ``PillboxView/PillView/completedTask(state:completionHandler:)`` or ``PillboxView/PillView/showError(message:vcView:)``.
    public private(set) var titleLabel = UXLabel()
    
    /// A Boolean value indicating whether the current ``PillboxView/PillView`` is waiting for a task to complete.
    ///
    /// Make sure this message is short and concise; otherwise, it will hang off the ``PillboxView/PillView/pillView``, assuming the use of the default ``PillboxView/PillView/width`` value of  `200`
    /// This ``PillboxView/PillView/titleLabel`` is left-center aligned, and the ``PillboxView/PillView/activityIndicator`` is right-center aligned.
    ///
    /// This only applies if the current ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/ongoingTask``
    public var isAwaitingTaskCompletion = false
    
    /// Shows the success symbol that should be used.
    ///
    /// Note: This will only be used for the ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/ongoingTask``.
    /// Make sure that the symbol forms an even aspect ration of 30 by 30 for the best quality.
    ///
    #if os(macOS)
    public var successSymbol = UXImage(systemSymbolName: "checkmark.circle", accessibilityDescription: "Checkmark")
    #else
    public var successSymbol = UXImage(symbolName: "checkmark.circle")
    #endif
    
    /// Shows the failure symbol that should be used.
    ///
    /// Note: This will only be used for the ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/ongoingTask``.
    /// Make sure that the symbol forms an even aspect ration of 30 by 30 for the best quality.
    #if os(macOS)
    public var failureSymbol = UXImage(systemSymbolName: "x.circle", accessibilityDescription: "Error X symbol")!
    #else
    public var failureSymbol = UXImage(symbolName: "x.circle")!
    #endif
    
    /// Shows the error symbol that should be used.
    ///
    /// Note: This will only be used for the ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/error``.
    /// Make sure that the symbol forms an even aspect ration of 30 by 30 for the best quality.
    #if os(macOS)
    public var errorSymbol = UXImage(systemSymbolName: "wifi.exclamationmark", accessibilityDescription: "Wifi error")!
    #else
    public var errorSymbol = UXImage(symbolName: "wifi.exclamationmark")!

    #endif
    /// The desired `UXView` that you would like the ``PillboxView/PillView/pillView`` displayed on.
    ///
    /// Most of the time, this will be your `ViewController.view`, since `view` is derived from the `UIStoryboard`.
    ///
    /// Note: ``PillboxView/PillView`` does not need to be placed on a `UXViewController`, but could be placed on any such `UXView`.
    public private(set) weak var vcView: UXView!
    
    /// This helps developers determine which type the ``PillboxView/PillShowType``.
    ///
    /// This is set automatically, and cannot be changed. This could come handy when you would want to filter out a specific case from the ``PillboxView/PillView/activePillBoxViews``.
    public private(set) var showType: PillShowType? = nil
    
    /// A Boolean value to allowing ``PillboxView/PillView`` to work around having a `UINavigationController` at the top of the screen.
    ///
    /// The `UINavigationController` can block the top of the screen, thus obstructing the ``PillboxView/PillView/pillView``
    /// Set this to true to let the ``PillboxView/PillView/pillView`` ``PillboxView/PillView/reveal(animated:completionHandler:)`` 40 pixels higher (y-axis, lower down on the screen from the top in UIKit world).
    public var isNavigationControllerPresent = Bool()
    
    /// The font to be used for displaying ``PillboxView/PillView`` messages on the screen.
    /// By default, the font is nil and defaults to the normal font.
    public private(set) var font: UXFont? = nil
    
    /// The `Set` holds unique ``PillboxView/PillView`` shown on the screen at the given time.
    ///
    /// When ``PillboxView/PillView`` exit the screen, they are removed from this `Set`. There are numerous use cases for this:
    /// - checking the number of ``PillboxView/PillView`` on the screen, so you can limit pills residing on the ``PillboxView/PillView/vcView``.
    /// - Filter out a specific case from the ``PillboxView/PillView/activePillBoxViews``.
//    public private(set) static var activePillBoxViews = Set<PillView>()
    
    /// The basic initialization of ``PillboxView/PillView``, which includes all of the default parameters.
    ///
    /// Use the other initializers to set fields/values of the ``PillboxView/PillView``. While you could modify some of the fields/properties with default values, some of them cannot be mutated.
    public init() {
        super.init(frame: NSZeroRect)
        self._internalInit()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self._internalInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self._internalInit()
    }
    
    private func _internalInit() {
        #if os(macOS)
        self.wantsLayer = true
        #endif
        self.frame.size = CGSize(width: self.width, height: self.height)
    }
    
    /// This sets the ``PillboxView/PillView/showType`` ahead of when the computer will automatically set the value of this.
    ///
    /// The computer sets the value of this through the following functions:
    /// - ``PillboxView/PillView/showTask(message:vcView:)``
    /// - ``PillboxView/PillView/showError(message:vcView:)``
    ///
    /// Note that ``PillboxView/PillView`` does not rely on this value, and is supposed to be for the developer's benefit/knowledge.
    ///
    /// - Parameter showType: This helps developers determine which type the ``PillboxView/PillShowType``.
    /// - Parameter font: This specifies the font to be user to display ``PillboxView/PillView`` messages
    ///     Default is nil which will used the default font for the platform
    /// - Parameter isNavigationControllerPresent: A Boolean value to allowing ``PillboxView/PillView`` to work around having a `UINavigationController` at the top of the screen.
    ///     The default value of this is false.
    public convenience init(showType: PillShowType? = nil, font: UXFont? = nil, isNavigationControllerPresent: Bool = false) {
        self.init(frame: NSZeroRect)
        self.frame.size = CGSize(width: self.width, height: self.height)

        self.showType = showType
        self.font = font
        self.isNavigationControllerPresent = isNavigationControllerPresent
    }
        
    /// Initialize this value overriding the ``PillboxView/PillView/isNavigationControllerPresent`` value
    public convenience init(isNavigationControllerPresent: Bool) {
        self.init(frame: NSZeroRect)

        self.isNavigationControllerPresent = isNavigationControllerPresent
    }
    
    /// Initializes with different values than the default width and height values
    ///
    /// - Parameters:
    ///   - width: The width of the ``PillboxView/PillView/pillView``.
    ///   - height: The height of the ``PillboxView/PillView/pillView``.
    public convenience init(width: Int, height: Int) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))

        self.width  = width
        self.height = height
        self.showType = nil
    }
    
    /// This allows developers to use their own `UXActivityIndicator` instead of the default.
    ///
    /// This can open a wide range of possibilities, including style, color, and animation preferences.
    /// - Parameter activityIndicator: A `UXSpinner` for the asynchronous task of the ``PillboxView/PillShowType/ongoingTask``.
    public convenience init(activityIndicator: UXSpinner) {
        self.init(frame: NSZeroRect)

        self.activityIndicator = activityIndicator
        self.showType = nil
    }
    
    /// Shows the result of your asynchronous task as a positive or negative
    ///
    /// Displays an animation that hides the ``PillboxView/PillView/activityIndicator`` and animates to ``PillboxView/PillView/successSymbol`` or ``PillboxView/PillView/failureSymbol`` image based on the `state` provided.
    ///
    /// In total, the animation takes 3 seconds to complete (3 seconds run asynchronously/parallel against ``PillboxView/PillView/dismiss(animated:completionHandler:)``.
    ///
    /// When the animation is complete, the views are destroyed or removed from the ``PillboxView/PillView/vcView`` and ``PillboxView/PillView/isAwaitingTaskCompletion`` is set to `false`. Additionally, the `completionHandler` is called. Finally, ``PillboxView/PillView/showType`` is set to `nil`.
    ///
    /// This should only be used when ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/ongoingTask``.
    ///
    /// - Parameters:
    ///   - state: A Boolean value indicating whether the asynchronous task the ``PillboxView/PillView`` has been waiting on has been successful (true) or unsuccessful (false).
    ///   - message: An updated message to be displayed when completing a task.
    ///   - timeBeforeMoveOut: Time in secs to wait before moving the pill out of sight
    ///   - completionHandler: A completion handler indicating when the animation has finished.
    open func completedTask(state: Bool, message: String? = nil, timeBeforeMoveOut: TimeInterval = 1.5, completionHandler: (() -> Void)? = nil) {
//        PillView.activePillBoxViews.remove(self)
        
        DispatchQueue.main.async { [self] in
            guard
                let titleLabel = self.viewWithTag(1) as? UXLabel,
                let imageView  = self.viewWithTag(2) as? UXImageView
            else { return }
            
            // Display the new message upon completion is specified
            if let message = message {
                titleLabel.text = message
            }
            
            imageView.image = state ? self.successSymbol : self.failureSymbol
            imageView.tintColor = state ? UXColor.systemGreen  : UXColor.systemRed
            imageView.isHidden = true
            
            #if os(macOS)
            let viewAnimationKeys: [[NSViewAnimation.Key: Any]] =
            [[NSViewAnimation.Key.effect: NSViewAnimation.EffectName.fadeOut,
              NSViewAnimation.Key.target: self.activityIndicator],
             [NSViewAnimation.Key.effect: NSViewAnimation.EffectName.fadeIn,
              NSViewAnimation.Key.target: imageView]]
            
            let viewAnimation = NSViewAnimation(viewAnimations: viewAnimationKeys)
            viewAnimation.start()
            #else
            UIView.transition(from: self.activityIndicator, to: imageView, duration: 0.25, options: .transitionCrossDissolve) { _ in
                self.activityIndicator.isSpinning = false
                self.activityIndicator.isHidden = true
                imageView.isHidden = false
            }
            #endif
            
            // Dismiss the pill
            self.dismiss(timeBeforeMoveOut: timeBeforeMoveOut) {
                // And remove all elements from the view hierarchy
                imageView.removeFromSuperview()
                titleLabel.removeFromSuperview()
               
                self.removeFromSuperview()
                self.showType = nil
                
                if let completionHandler = completionHandler { completionHandler() }
                self.isAwaitingTaskCompletion = false
            }
        }
    }
    
    
    /// Starts the acknowledgement of the asynchronous task to the main UI
    ///
    /// The animation starts off by the ``PillboxView/PillView/pillView`` sliding into the view, preset with all of the `UI` components filled out. The animation, in total, takes 1 second. Finally, ``PillboxView/PillView/isAwaitingTaskCompletion`` is set to `true`.
    ///
    /// This should only be used when ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/ongoingTask``.
    ///
    /// - Parameters:
    ///   - message: The desired message the ``PillboxView/PillView/titleLabel`` should present.
    ///   Make sure this message is short and concise; otherwise, it will hang off the ``PillboxView/PillView/pillView``, assuming the use of the default ``PillboxView/PillView/width`` value of  `200`
    ///   This ``PillboxView/PillView/titleLabel`` is left-center aligned, and the ``PillboxView/PillView/activityIndicator`` is right-center aligned.
    ///   - vcView: The desired `UIView` that you would like the ``PillboxView/PillView/pillView`` displayed on.
    ///   - tintColor: A tint color for the `UIImageView` of the ``PillboxView/PillView/pillView/`` displayed on.
    ///   - completionHandler: A completion handler indicating when the animation has finished.
    open func showTask(message: String, vcView: UXView, tintColor: UXColor = UXColor.systemBlue, completionHandler: (() -> Void)? = nil) {
        // Now configure against the view hierarchy. Mostly centering the pill initial position
        self.configurePill(parentView: vcView)

        self.showType = .ongoingTask
                
        // titleLabel which should be centered within the superview
        self.titleLabel = UXLabel(frame: UXRect(x: 0,
                                                y: 6,
                                                width: self.frame.width - 40,
                                                height: 23))

        self.titleLabel.text = message
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = self.font
        #if os(macOS)
        self.titleLabel.isBordered = false
        #endif
        self.titleLabel.textColor = UXColor.PillboxTitleColor
        self.titleLabel.backgroundColor = .clear
        self.titleLabel.tag = 1
        
        // activityIndicator
        self.activityIndicator = UXSpinner(frame: UXRect(x: self.titleLabel.frame.maxX,
                                                         y: 10,
                                                         width: 16,
                                                         height: 16))
        #if os(macOS)
        self.activityIndicator.style = .spinning
        self.activityIndicator.controlSize = .small
        #endif
        self.activityIndicator.isSpinning = true
        
        let imageView = UXImageView(frame: UXRect(x: self.titleLabel.frame.maxX,
                                                  y: 10,
                                                  width: 16,
                                                  height: 16))
        
        imageView.isHidden = true
        imageView.tintColor = tintColor
        imageView.tag = 2
        
        // moving/adding into view hierarchy
        self.addSubview(titleLabel)
        self.addSubview(activityIndicator)
        self.addSubview(imageView)

        #if os(macOS)
        NSAnimationContext.runAnimationGroup{ context in
            context.duration = 1.0
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

            // Need to calculate the origin of the pill view from the center point
            let origin = self.originForCenter(inRelationTo: vcView)
            let yPos = vcView.frame.height /* Offset below top edge (negative value) */ - 50.0
            self.frame.origin = CGPoint(x: origin.x, y: yPos)
        }
        #else
        UIView.animate(withDuration: 1) {
            self.pillView.frame = UXRect(x: Int(vcView.frame.midX),
                                         y: UIDevice.current.hasNotch ? 45: 25 + (self.isNavigationControllerPresent ? 40 : 0),
                                         width: self.width, height: self.height)
            
            self.pillView.center.x = vcView.center.x
            
            if let completionHandler = completionHandler { completionHandler() }
        }

//        vcView.addSubview(self.pillView)
        #endif
        
        self.isAwaitingTaskCompletion = true
    }
    
    /// Starts the acknowledgement of the error of an instant task to the main UI.
    ///
    /// This should only be used when ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/error``.
    ///
    /// The sliding in animation starts off by the ``PillboxView/PillView/pillView`` sliding into the view, preset with all of the `UI` components filled out. This animation, in total, takes 1 second. After waiting three seconds, ``PillboxView/PillView/dismiss(animated:completionHandler:)`` is called, and it receeds after 4 more seconds. The total animation time is be 7 seconds because the animations run asynchronous/parallel.
    ///
    /// The ``PillboxView/PillView/isAwaitingTaskCompletion`` is not set to `true` here because of the only use of ``PillboxView/PillShowType/error``.
    ///
    /// - Parameters:
    ///   - message: The desired message the ``PillboxView/PillView/titleLabel`` should present.
    ///   Make sure this message is short and concise; otherwise, it will hang off the ``PillboxView/PillView/pillView``, assuming the use of the default ``PillboxView/PillView/width`` value of  `200`
    ///   This ``PillboxView/PillView/titleLabel`` is left-center aligned, and the ``PillboxView/PillView/activityIndicator`` is right-center aligned.
    ///   - vcView: The desired `UIView` that you would like the ``PillboxView/PillView/pillView`` displayed on.
    ///   - tintColor: A tint color for the `UIImageView` of the ``PillboxView/PillView/pillView/`` displayed on.
    ///   - timeToShow: Length of time to show in seconds/double (`TimeInterval`). Note that this should be at least `2` seconds and that this does not include the animation times. See source code for animation timings
    ///   - completionHandler: A completion handler indicating when the animation has finished.
    public func showError(message: String, vcView: UXView, tintColor: UXColor? = .systemRed, timeToShow: TimeInterval = 2, completionHandler: (() -> Void)? = nil) {
        self.configurePill(parentView: vcView)

        let timeToShowErrorPill = timeToShow < 2 ? 2 : timeToShow
        self.showType = .error
     
        // titleLabel
        self.titleLabel = UXLabel(frame: UXRect(x: 0, y: 6, width: self.frame.width - 40, height: 23))
        self.titleLabel.text = message
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = self.font
        self.titleLabel.textColor = UXColor.PillboxTitleColor
        self.titleLabel.backgroundColor = .clear

        #if os(macOS)
        self.titleLabel.isBordered = false
        #endif
        self.titleLabel.tag = 3

        // imageView
        let imageView = UXImageView(frame: UXRect(x: titleLabel.frame.maxX,
                                                  y: 6,
                                                  width: (self.frame.width - 15) - titleLabel.frame.maxX,
                                                  height: 23))

        imageView.image = errorSymbol
        imageView.tintColor = tintColor
        imageView.tag = 4

        // moving/adding into frame
        self.addSubview(titleLabel)
        self.addSubview(imageView)

        #if os(macOS)
        // Need to calculate the origin of the pill view from the center point
        let originX = self.originForCenter(inRelationTo: self.vcView).x
        let originY = self.vcView.frame.height /* Offset from top edge */ - 50.0

        NSAnimationContext.runAnimationGroup{ context in
            context.duration = 1.0
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

            self.frame.origin = UXPoint(x: originX, y: originY)
            // Need to center the pillView within the vcView
            // Using autolayout constaints
            //self.pillView.centerXAnchor.constraint(equalTo: vcView.centerXAnchor).isActive = true
            //self.pillView.center.x = vcView.center.x
        }
        #else
            UIView.animate(withDuration: 1) {
                self.pillView.frame = UXRect(x: 100,
                                             y: UIDevice.current.hasNotch ? 45: 25 + (self.isNavigationControllerPresent ? 40 : 0),
                                             width: self.width,
                                             height: self.height)
                self.pillView.center.x = vcView.center.x
            }
        #endif
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 + timeToShowErrorPill) {
            self.dismiss()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5 + timeToShowErrorPill) {
            imageView.removeFromSuperview()
            self.titleLabel.removeFromSuperview()

            // Fix Issue 25: PillView not removed from view hierarchy
            self.removeFromSuperview()

            self.showType = nil
            if let completionHandler = completionHandler { completionHandler() }
        }
    }
    
    /// Common configuration settings
    private func configurePill(parentView: UXView) {
        let originX = self.originForCenter(inRelationTo: parentView).x
        let originY = parentView.frame.height /* Offset above top edge (positive value) */ + 50.0
        self.frame.origin = CGPoint(x: originX, y: originY)
        
        #if os(macOS)
        // Define our shadow
        let shadow              = NSShadow()
        shadow.shadowColor      = UXColor.black.withAlphaComponent(0.2)
        shadow.shadowOffset     = CGSizeMake(0.0, -3.0)
        shadow.shadowBlurRadius = 10.0
        
        // Make our view layer-backed
        self.wantsLayer = true
        self.shadow = shadow
        
        // Define our pill property
        self.layer!.backgroundColor = UXColor.PillboxBackgroundColor.cgColor
        self.layer!.cornerRadius  = 10
        self.layer!.borderColor   = UXColor.lightGray.cgColor
        self.layer!.borderWidth   = 0.2

        #else
        let layer = self.layer
        layer.backgroundColor = UXColor.PillboxBackgroundColor
        layer.cornerRadius  = 20
        layer.shadowOpacity = 0.1
        layer.shadowOffset  = .zero
        layer.shadowColor   = UXColor.black.cgColor
        layer.shadowRadius  = 10
        #endif

        // And add resizing mask so both the left and right side has flexible margins
        // and pill is horizontally centered into containing view.
        self.autoresizingMask = [.minXMargin, .maxXMargin]
        parentView.addSubview(self)
        self.vcView = parentView
    }
}

#if os(iOS)
extension UIDevice {
    internal var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
#endif
