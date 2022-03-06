//
//  PillView.swift
//  PillboxView
//
//  Created by Jacob Trentini on 12/30/21.
//

import UIKit

/// A `UIView` to display two forms of dynamic content based on the conditions or needs of a developer.
public class PillView {
    
    /// The `UIView` itself that holds the content of the ``PillboxView/PillView``, such as a title and imageView.
    ///
    ///  This shows information based on the ``PillboxView/PillShowType``.
    ///  Both causes hold a title/message `UILabel` and a  `UIImageView`, customizable to the developer's suitable needs.
    public var pillView = UIView()
    
    /// The width of the ``PillboxView/PillView/pillView``.
    public var width = 200
    
    /// The height of the ``PillboxView/PillView/pillView``.
    ///
    /// If a `UINavigationController` obstructs it, then set ``PillboxView/PillView/isNavigationControllerPresent`` to `true`
    public var height = 45
    
    /// A `UIActivityIndicatorView` for the asynchronous task of the ``PillboxView/PillShowType/ongoingTask``.
    ///
    /// This should not be used if using ``PillboxView/PillShowType/error``
    public private(set) var activityIndicator = UIActivityIndicatorView()
    
    /// A `UILabel` align on the ``PillboxView/PillView/pillView``'s center-left to display a message.
    ///
    /// The message should not be set through accessing the properties of this label, but rather ``PillboxView/PillView/completedTask(state:completionHandler:)`` or ``PillboxView/PillView/showError(message:vcView:)``.
    public private(set) var titleLabel = UILabel()
    
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
    public var successSymbol = UIImage(systemName: "checkmark.circle")!
    
    /// Shows the failure symbol that should be used.
    ///
    /// Note: This will only be used for the ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/ongoingTask``.
    /// Make sure that the symbol forms an even aspect ration of 30 by 30 for the best quality.
    public var failureSymbol = UIImage(systemName: "x.circle")!
    
    
    /// Shows the error symbol that should be used.
    ///
    /// Note: This will only be used for the ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/error``.
    /// Make sure that the symbol forms an even aspect ration of 30 by 30 for the best quality.
    public var errorSymbol = UIImage(systemName: "wifi.exclamationmark")!
    
    /// The desired `UIView` that you would like the ``PillboxView/PillView/pillView`` displayed on.
    ///
    /// Most of the time, this will be your `ViewController.view`, since `view` is derived from the `UIStoryboard`.
    ///
    /// Note: ``PillboxView/PillView`` does not need to be placed on a `UIViewController`, but could be placed on any such `UIView`.
    public private(set) var vcView: UIView?
    
    /// This helps developers determine which type the ``PillboxView/PillShowType``.
    ///
    /// This is set automatically, and cannot be changed. This could come handy when you would want to filter out a specific case from the ``PillboxView/PillView/activePillBoxViews``.
    public private(set) var showType: PillShowType? = nil
    
    /// A Boolean value to allowing ``PillboxView/PillView`` to work around having a `UINavigationController` at the top of the screen.
    ///
    /// The `UINavigationController` can block the top of the screen, thus obstructing the ``PillboxView/PillView/pillView``
    /// Set this to true to let the ``PillboxView/PillView/pillView`` ``PillboxView/PillView/reveal(animated:completionHandler:)`` 40 pixels higher (y-axis, lower down on the screen from the top).
    public var isNavigationControllerPresent = Bool()
    
    /// The `Set` holds unique ``PillboxView/PillView`` shown on the screen at the given time.
    ///
    /// When ``PillboxView/PillView`` exit the screen, they are removed from this `Set`. There are numerous use cases for this:
    /// - checking the number of ``PillboxView/PillView`` on the screen, so you can limit pills residing on the ``PillboxView/PillView/vcView``.
    /// - Filter out a specific case from the ``PillboxView/PillView/activePillBoxViews``.
    public private(set) static var activePillBoxViews = Set<PillView>()
    
    /// The basic initialization of ``PillboxView/PillView``, which includes all of the default parameters.
    ///
    /// Use the other initializers to set fields/values of the ``PillboxView/PillView``. While you could modify some of the fields/properties with default values, some of them cannot be mutated.
    /// Note that ``PillboxView/PillView`` does not rely on this value, and is supposed to be for the developer's benefit/knowledge.
    public init() { }
    
    /// This sets the ``PillboxView/PillView/showType`` ahead of when the computer will automatically set the value of this.
    ///
    /// The computer sets the value of this through the following functions:
    /// - ``PillboxView/PillView/showTask(message:vcView:)``
    /// - ``PillboxView/PillView/showError(message:vcView:)``
    ///
    /// Note that ``PillboxView/PillView`` does not rely on this value, and is supposed to be for the developer's benefit/knowledge.
    ///
    /// - Parameter showType: This helps developers determine which type the ``PillboxView/PillShowType``.
    public init(showType: PillShowType) {
        self.showType = showType
    }
    
    /// Initialize this value overriding the ``PillboxView/PillView/isNavigationControllerPresent`` value
    /// - Parameter isNavigationControllerPresent: A Boolean value to allowing ``PillboxView/PillView`` to work around having a `UINavigationController` at the top of the screen.
    ///
    /// The default value of this is false.
    public init(isNavigationControllerPresent: Bool) {
        self.isNavigationControllerPresent = isNavigationControllerPresent
    }
    
    /// Initializes with different values than the default width and height values
    ///
    /// - Parameters:
    ///   - width: The width of the ``PillboxView/PillView/pillView``.
    ///   - height: The height of the ``PillboxView/PillView/pillView``.
    public init(width: Int, height: Int) {
        self.width  = width
        self.height = height
        self.showType = nil
    }
    
    /// This allows developers to use their own `UIActivityIndicator` instead of the default.
    ///
    /// This can open a wide range of possibilities, including style, color, and animation preferences.
    /// - Parameter activityIndicator: A `UIActivityIndicatorView` for the asynchronous task of the ``PillboxView/PillShowType/ongoingTask``.
    public init(activityIndicator: UIActivityIndicatorView) {
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
    ///   - completionHandler: A completion handler indicating when the animation has finished.
    open func completedTask(state: Bool, completionHandler: (() -> Void)? = nil) {
        PillView.activePillBoxViews.remove(self)
        
        DispatchQueue.main.async { [self] in
            guard
                let titleLabel = pillView.viewWithTag(1) as? UILabel,
                let imageView  = pillView.viewWithTag(2) as? UIImageView
            else { return }
            
            imageView.image     = state ? successSymbol : failureSymbol
            imageView.tintColor = state ? .systemGreen  : .systemRed
            imageView.isHidden = true
            
            UIView.transition(from: self.activityIndicator, to: imageView, duration: 0.25, options: .transitionCrossDissolve) { _ in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                imageView.isHidden = false
            }
            
            dismiss()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                imageView.removeFromSuperview()
                titleLabel.removeFromSuperview()
                self.showType = nil
                
                if let completionHandler = completionHandler { completionHandler() }
            }
            
            isAwaitingTaskCompletion = false
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
    open func showTask(message: String, vcView: UIView, tintColor: UIColor?, completionHandler: (() -> Void)? = nil) {
        
        self.showType = .ongoingTask
        
        self.vcView = vcView
        PillView.activePillBoxViews.insert(self)
        
        // pillView init
        pillView.frame = CGRect(x: Int(vcView.frame.midX), y: -300, width: width, height: height)
        pillView.center.x = vcView.center.x
        pillView.backgroundColor = UIColor.PillboxBackgroundColor
        pillView.layer.cornerRadius = 20
        
        // shadow for pillView
        pillView.layer.shadowColor   = UIColor.black.cgColor
        pillView.layer.shadowOpacity = 0.1
        pillView.layer.shadowOffset  = .zero
        pillView.layer.shadowRadius  = 10
        
        // titleLabel
        titleLabel = UILabel(frame: CGRect(x: 0,
                                           y: 11,
                                           width: pillView.frame.width - 40,
                                           height: 23))
        titleLabel.text = message
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.PillboxTitleColor
        titleLabel.tag = 1
        
        // activityIndicator
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: titleLabel.frame.maxX,
                                                                  y: 11,
                                                                  width: (pillView.frame.width - 15) - titleLabel.frame.maxX,
                                                                  height: 23))
        activityIndicator.startAnimating()
        
        let imageView = UIImageView(frame: CGRect(x: titleLabel.frame.maxX,
                                                  y: 11,
                                                  width: (pillView.frame.width - 15) - titleLabel.frame.maxX,
                                                  height: 23))
        
        imageView.isHidden = true
        imageView.tintColor = tintColor
        imageView.tag = 2
        
        // moving/adding into frame
        
        pillView.addSubview(titleLabel)
        pillView.addSubview(activityIndicator)
        pillView.addSubview(imageView)
        
        UIView.animate(withDuration: 1) {
            
            self.pillView.frame = CGRect(x: Int(vcView.frame.midX),
                                         y: UIDevice.current.hasNotch ? 45: 25 + (self.isNavigationControllerPresent ? 40 : 0),
                                         width: self.width, height: self.height)
            
            self.pillView.center.x = vcView.center.x
            
            if let completionHandler = completionHandler { completionHandler() }
        }
        
        vcView.addSubview(pillView)
        
        isAwaitingTaskCompletion = true
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
    public func showError(message: String, vcView: UIView, tintColor: UIColor? = .systemRed, timeToShow: TimeInterval = 2, completionHandler: (() -> Void)? = nil) {
        
        let timeToShowErrorPill = timeToShow < 2 ? 2 : timeToShow
        
        self.showType = .error
        
        // pillView init
        pillView.frame = CGRect(x: 100, y: -300, width: width, height: height)
        pillView.backgroundColor = UIColor.PillboxBackgroundColor
        pillView.layer.cornerRadius = 20

        // shadow for pillView
        pillView.layer.shadowColor = UIColor.black.cgColor
        pillView.layer.shadowOpacity = 0.1
        pillView.layer.shadowOffset = .zero
        pillView.layer.shadowRadius = 10

        // titleLabel
        titleLabel = UILabel(frame: CGRect(x: 0, y: 11, width: pillView.frame.width - 40, height: 23))
        titleLabel.text = message
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.PillboxTitleColor
        titleLabel.tag = 3

        // imageView
        let imageView = UIImageView(frame: CGRect(x: titleLabel.frame.maxX,
                                                  y: 11,
                                                  width: (pillView.frame.width - 15) - titleLabel.frame.maxX,
                                                  height: 23))

        imageView.tag = 4
        imageView.image = errorSymbol
        imageView.tintColor = tintColor

        // moving/adding into frame

        pillView.addSubview(titleLabel)
        pillView.addSubview(imageView)

        UIView.animate(withDuration: 1) {
            self.pillView.frame = CGRect(x: 100,
                                         y: UIDevice.current.hasNotch ? 45: 25 + (self.isNavigationControllerPresent ? 40 : 0),
                                         width: self.width,
                                         height: self.height)
            self.pillView.center.x = vcView.center.x
        }
        
        vcView.addSubview(pillView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 + timeToShowErrorPill) {
            self.dismiss()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5 + timeToShowErrorPill) {
            imageView.removeFromSuperview()
            self.titleLabel.removeFromSuperview()
            self.showType = nil
            if let completionHandler = completionHandler { completionHandler() }
        }
    }
}

extension UIDevice {
    internal var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
