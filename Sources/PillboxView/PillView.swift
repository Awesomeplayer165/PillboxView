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
#elseif canImport(UIKit)
import UIKit
#endif

// ---
import NSUI     // To unify AppKit and UIKit and add macOS compatibility


/// A `NSUIView` to display two forms of dynamic content based on the conditions or needs of a developer.
public class PillView: NSUIView {
    /// The `NSUIView` itself that holds the content of the ``PillboxView/PillView``, such as a title and imageView.
    ///
    ///  This shows information based on the ``PillboxView/PillShowType``.
    ///  Both causes hold a title/message `NSUILabel` and a  `NSUIImageView`, customizable to the developer's suitable needs.
    
    // ?? Do we need to define another UXView here. This implementation is deriving from UXView ??
    // public var pillView = UXView()

    /// The width of the ``PillboxView/PillView/pillView``.
    private static let defaultWidth: CGFloat = 400
    public var width: CGFloat {
        return self.frame.width
    }
    
    /// The height of the ``PillboxView/PillView/pillView``.
    ///
    /// If a `UINavigationController` obstructs it, then set ``PillboxView/PillView/isNavigationControllerPresent`` to `true`
    private static let defaultHeight: CGFloat = 200
    public var height: CGFloat {
        return self.frame.height
    }
    
    /// A `NSSpinner` aka `NSUIActivityIndicatorView` in UIKIt for the asynchronous task of the ``PillboxView/PillShowType/ongoingTask``.
    ///
    /// This should not be used if using ``PillboxView/PillShowType/error``
    public private(set) var activityIndicator = NSUIActivityIndicatorView()
    
    /// A `NSUILabel` align on the ``PillboxView/PillView/pillView``'s center-left to display a message.
    ///
    /// The message should not be set through accessing the properties of this label, but rather ``PillboxView/PillView/completedTask(state:completionHandler:)`` or ``PillboxView/PillView/showError(message:vcView:)``.
    public private(set) var titleLabel = NSUILabel()
    
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
    public var successSymbol = NSUIImage(systemName: "checkmark.circle")
    
    /// Shows the failure symbol that should be used.
    ///
    /// Note: This will only be used for the ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/ongoingTask``.
    /// Make sure that the symbol forms an even aspect ration of 30 by 30 for the best quality.
    public var failureSymbol = NSUIImage(systemName: "x.circle")!
    
    /// Shows the error symbol that should be used.
    ///
    /// Note: This will only be used for the ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/error``.
    /// Make sure that the symbol forms an even aspect ration of 30 by 30 for the best quality.
    public var errorSymbol = NSUIImage(systemName: "wifi.exclamationmark")!

    /// The parent `NSUIView` that you would like the ``PillboxView/PillView/pillView`` displayed on.
    ///
    /// Note: ``PillboxView/PillView`` does not need to be placed on a `NSUIViewController`, but could be placed on any such `NSUIView`.
    public private(set) weak var vcView: NSUIView!
    
    /// This helps developers determine which type the ``PillboxView/PillShowType``.
    ///
    /// This is set automatically, and cannot be changed. This could come handy when you would want to filter out a specific case from the ``PillboxView/PillView/activePillBoxViews``.
    public private(set) var showType: PillShowType? = nil
    
    #if os(iOS)
    /// A Boolean value to allowing ``PillboxView/PillView`` to work around having a `UINavigationController` at the top of the screen.
    ///
    /// The `UINavigationController` can block the top of the screen, thus obstructing the ``PillboxView/PillView/pillView``
    /// Set this to true to let the ``PillboxView/PillView/pillView`` ``PillboxView/PillView/reveal(animated:completionHandler:)`` 40 pixels higher (y-axis, lower down on the screen from the top in UIKit world).
    public var isNavigationControllerPresent = Bool()
    #endif
    
    /// The font to be used for displaying ``PillboxView/PillView`` messages on the screen.
    /// By default, the font is nil and defaults to the normal font.
    public private(set) var font: NSUIFont? = nil
    
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
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: Self.defaultWidth, height: Self.defaultHeight)))
        self._internalInit()
    }
    
    public override init(frame frameRect: CGRect) {
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
       // self.frame.size = CGSize(width: self.width, height: self.height)
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
    #if os(macOS)
    public convenience init(showType: PillShowType? = nil, font: NSUIFont? = nil) {
        self.init()
        self.showType = showType
        self.font = font
    }
    #else
    public convenience init(showType: PillShowType? = nil, font: NSUIFont? = nil, isNavigationControllerPresent: Bool = false) {
        self.init()
        self.showType = showType
        self.font = font
        
        self.isNavigationControllerPresent = isNavigationControllerPresent
    }
    #endif
    
    #if os(iOS)
    /// Initialize this value overriding the ``PillboxView/PillView/isNavigationControllerPresent`` value
    public convenience init(isNavigationControllerPresent: Bool) {
        self.init()
        self.isNavigationControllerPresent = isNavigationControllerPresent
    }
    #endif
    
    
    /// Initializes with different values than the default width and height values
    ///
    /// - Parameters:
    ///   - width: The width of the ``PillboxView/PillView/pillView``.
    ///   - height: The height of the ``PillboxView/PillView/pillView``.
    public convenience init(width: Int, height: Int) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))

        /*
        self.width  = width
        self.height = height
        */
        self.showType = nil
    }
    
    /// This allows developers to use their own `ActivityIndicator` instead of the default.
    ///
    /// This can open a wide range of possibilities, including style, color, and animation preferences.
    /// - Parameter activityIndicator: A `NSUIActivityIndicatorView` for the asynchronous task of the ``PillboxView/PillShowType/ongoingTask``.
    public convenience init(activityIndicator: NSUIActivityIndicatorView) {
        self.init()

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
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard
                let titleLabel = self.viewWithTag(1) as? NSUILabel,
                let imageView  = self.viewWithTag(2) as? NSUIImageView
            else { return }
            
            // Display the new message upon completion is specified
            if let message = message {
                titleLabel.text = message
            }
            
            imageView.image = state ? self.successSymbol : self.failureSymbol
            imageView.tintColor = state ? NSUIColor.systemGreen  : NSUIColor.systemRed
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
                self.activityIndicator.stopAnimating()
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
    ///   - vcView: The desired `NSUIView` that you would like the ``PillboxView/PillView/pillView`` displayed on.
    ///   - tintColor: A tint color for the `NSUIImageView` of the ``PillboxView/PillView/pillView/`` displayed on.
    ///   - completionHandler: A completion handler indicating when the animation has finished.
    open func showTask(message: String, vcView: NSUIView, tintColor: NSUIColor = NSUIColor.systemBlue, completionHandler: (() -> Void)? = nil) {
        // Now configure against the view hierarchy. Mostly centering the pill initial position
        self.configurePill(parentView: vcView)

        self.showType = .ongoingTask
                
        // titleLabel which should be centered within the superview
        self.titleLabel = NSUILabel(frame: CGRect(x: 0,
                                                  y: 6,
                                                  width: self.frame.width - 40,
                                                  height: 23))

        self.titleLabel.text = message
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = self.font
        #if os(macOS)
        self.titleLabel.isBordered = false
        #endif
        self.titleLabel.textColor = NSUIColor.PillboxTitleColor
        self.titleLabel.backgroundColor = .clear
        self.titleLabel.tag = 1
        self.centerVertically(subview: self.titleLabel, horizontalAlignment: .leading)

        // Setup activityIndicator
        self.activityIndicator = NSUIActivityIndicatorView(frame: CGRect(x: self.titleLabel.frame.maxX,
                                                           y: 10,
                                                           width: 16,
                                                           height: 16))
        #if os(macOS)
        self.activityIndicator.style = .spinning
        self.activityIndicator.controlSize = .small
        #endif
        self.activityIndicator.startAnimating()
        self.centerVertically(subview: self.activityIndicator, horizontalAlignment: .trailing)
        
        // Setup completed task imageView
        let imageView = NSUIImageView(frame: CGRect(x: self.titleLabel.frame.maxX,
                                                    y: 10,
                                                    width: 16,
                                                    height: 16))
        
        imageView.isHidden = true
        imageView.tintColor = tintColor
        imageView.tag = 2
        self.centerVertically(subview: imageView, horizontalAlignment: .trailing)
            
        // Inserting into view hierarchy
        self.addSubview(titleLabel)
        self.addSubview(activityIndicator)
        self.addSubview(imageView)

        #if os(macOS)
        NSAnimationContext.runAnimationGroup{ context in
            context.duration = 1.0
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

            // Need to calculate the origin of the pill view from the center point
            let origin = self.originForCenter(inRelationTo: vcView)
            let yPos = vcView.frame.height /* Offset below top edge (negative value) */ - 50.0
            self.frame.origin = CGPoint(x: origin.x, y: yPos)
        }
        #else
        NSUIView.animate(withDuration: 1) {
            self.frame = CGRect(x: vcView.frame.midX,
                                y: UIDevice.current.hasNotch ? 45: 25 + (self.isNavigationControllerPresent ? 40 : 0),
                                width: self.width, height: self.height)
            
            self.center.x = vcView.center.x
            
            if let completionHandler = completionHandler { completionHandler() }
        }

//        vcView.addSubview(self.pillView)  /* This is not performed in the configurePill(parentView:) function
        #endif
        
        self.isAwaitingTaskCompletion = true
    }
    
    ///
    /// Update the task pill with a new message
    public func updateTask(message: String) {
        guard
            self.isAwaitingTaskCompletion
        else {
            return
        }
            
        // TODO: This new message should be animated to replace the previous one.
        self.titleLabel.text = message
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
    ///   - vcView: The desired `NSUIView` that you would like the ``PillboxView/PillView/pillView`` displayed on.
    ///   - tintColor: A tint color for the `UIImageView` of the ``PillboxView/PillView/pillView/`` displayed on.
    ///   - timeToShow: Length of time to show in seconds/double (`TimeInterval`). Note that this should be at least `2` seconds and that this does not include the animation times. See source code for animation timings
    ///   - completionHandler: A completion handler indicating when the animation has finished.
    public func showError(message: String, vcView: NSUIView, tintColor: NSUIColor? = .systemRed, timeToShow: TimeInterval = 2, completionHandler: (() -> Void)? = nil) {
        self.configurePill(parentView: vcView)

        let timeToShowErrorPill = timeToShow < 2 ? 2 : timeToShow
        self.showType = .error
     
        // titleLabel
        self.titleLabel = NSUILabel(frame: CGRect(x: 0, y: 6, width: self.frame.width - 40, height: 23))
        self.titleLabel.text = message
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = self.font
        self.titleLabel.textColor = NSUIColor.PillboxTitleColor
        self.titleLabel.backgroundColor = .clear

        #if os(macOS)
        self.titleLabel.isBordered = false
        #endif
        self.titleLabel.tag = 3

        // imageView
        let imageView = NSUIImageView(frame: CGRect(x: titleLabel.frame.maxX,
                                                    y: 6,
                                                    width: (self.frame.width - 15) - titleLabel.frame.maxX,
                                                    height: 23))

        imageView.image = errorSymbol
        imageView.tintColor = tintColor!
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
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

            self.frame.origin = CGPoint(x: originX, y: originY)
            // Need to center the pillView within the vcView
            // Using autolayout constaints
            //self.pillView.centerXAnchor.constraint(equalTo: vcView.centerXAnchor).isActive = true
            //self.pillView.center.x = vcView.center.x
        }
        #else
            UIView.animate(withDuration: 1) {
                self.frame = CGRect(x: 100,
                                    y: UIDevice.current.hasNotch ? 45: 25 + (self.isNavigationControllerPresent ? 40 : 0),
                                    width: self.width,
                                    height: self.height)
                self.center.x = vcView.center.x
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
    private func configurePill(parentView: NSUIView) {
        let originX = self.originForCenter(inRelationTo: parentView).x
        let originY = parentView.frame.height /* Offset above top edge (positive value) */ + 50.0
        self.frame.origin = CGPoint(x: originX, y: originY)
        
        #if os(macOS)
        // Define our shadow
        let shadow              = NSShadow()
        shadow.shadowColor      = NSUIColor.black.withAlphaComponent(0.2)
        shadow.shadowOffset     = CGSizeMake(0.0, -3.0)
        shadow.shadowBlurRadius = 10.0
        
        // Make our view layer-backed
        self.wantsLayer = true
        self.shadow = shadow
        
        // Define our pill property
        self.layer!.backgroundColor = NSUIColor.PillboxBackgroundColor.cgColor
        self.layer!.cornerRadius  = 20
        self.layer!.borderColor   = NSUIColor.lightGray.cgColor
        self.layer!.borderWidth   = 0.2

        // And add resizing mask so both the left and right side have flexible margins
        // and pill is horizontally centered into containing view when resizing
        self.autoresizingMask = [.minXMargin, .maxXMargin]

        #else
        let layer = self.layer
        layer.backgroundColor = NSUIColor.PillboxBackgroundColor.cgColor
        layer.cornerRadius  = 20
        layer.shadowOpacity = 0.1
        layer.shadowOffset  = .zero
        layer.shadowColor   = NSUIColor.black.cgColor
        layer.shadowRadius  = 10

        // And add resizing mask so both the left and right side have flexible margins
        // and pill is horizontally centered into containing view when resizing
        self.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        #endif
        
        // Add it to the hierarchy and retain parent
        parentView.addSubview(self)
        self.vcView = parentView
    }
    
    ///
    /// Vertically center a subview within the pillView with the specified horizontal alignment
    ///
    private func centerVertically(subview: NSUIView, horizontalAlignment: NSRectAlignment) {
        // TODO: This function is not doign anything useful yet...
        let originX = subview.frame.origin.x
        let originY = subview.frame.origin.y
        subview.frame = CGRect(origin: CGPoint(x: originX, y: originY), size: subview.frame.size)
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
