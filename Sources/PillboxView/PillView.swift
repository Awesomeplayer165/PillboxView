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
    /// If a `UINavigationController` obstructs it, then add `45` to the `y` value when the ``PillboxView/PillView/pillView`` completes the animation sliding in. This will be addressed shortly in the future
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
    
    
    /// /// Shows the error symbol that should be used.
    ///
    /// Note: This will only be used for the ``PillboxView/PillView/showType`` = ``PillboxView/PillShowType/error``.
    /// Make sure that the symbol forms an even aspect ration of 30 by 30 for the best quality.
    public var errorSymbol   = UIImage(systemName: "wifi.exclamationmark")!
    
    /// This is your desired `UIView` that you would like displayed on. Most of the time, this will be: your `ViewController.view`, since `view` is taken from the `UIStoryboard`.
    ///
    /// Note: ``PillboxView/PillView`` does not need to be placed on a `UIViewController`, but could be placed on any such `UIView`.
    public private(set) var vcView: UIView?
    
    /// This helps developers determine which type the ``PillboxView/PillShowType``.
    ///
    /// This is set automatically, and cannot be changed. This could come handy when you would want to filter out a specific case from the ``PillboxView/PillView/activePillBoxViews``.
    public private(set) var showType: PillShowType? = nil
    
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
    
    /// <#Description#>
    /// - Parameters:
    ///   - state: <#state description#>
    ///   - completionHandler: <#completionHandler description#>
    open func completedTask(state: Bool, completionHandler: (() -> Void)? = nil) {
        PillView.activePillBoxViews.remove(self)
        self.showType = nil
        
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
                
                if let completionHandler = completionHandler { completionHandler() }
            }
            
            isAwaitingTaskCompletion = false
        }
    }
    
    open func showTask(message: String, vcView: UIView) {
        
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
        imageView.tag = 2
        
        // moving/adding into frame
        
        pillView.addSubview(titleLabel)
        pillView.addSubview(activityIndicator)
        pillView.addSubview(imageView)
        
        UIView.animate(withDuration: 1) {
            
            self.pillView.frame = CGRect(x: Int(vcView.frame.midX),
                                         y: UIDevice.current.hasNotch ? 45: 25,
                                         width: self.width, height: self.height)
            
            self.pillView.center.x = vcView.center.x
        }
        
        vcView.addSubview(pillView)
        
        isAwaitingTaskCompletion = true
    }
    
    public func showError(message: String, vcView: UIView) {
        
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
        imageView.tintColor = .systemRed

        // moving/adding into frame

        pillView.addSubview(titleLabel)
        pillView.addSubview(imageView)

        UIView.animate(withDuration: 1) {
            self.pillView.frame = CGRect(x: 100, y: 45, width: self.width, height: self.height)
            self.pillView.center.x = vcView.center.x
        }
        
        vcView.addSubview(pillView)

        isAwaitingTaskCompletion = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            imageView.removeFromSuperview()
            self.titleLabel.removeFromSuperview()
            self.showType = nil
        }
    }
}

extension UIDevice {
    internal var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
