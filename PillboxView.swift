//
//  PillboxViewManager.swift
//  PillboxView
//
//  Created by Jacob Trentini on 12/30/21.
//

import UIKit

public enum PillboxShowType {
    case ongoingTask
    case error
}

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

open class PillboxView {
    open var pillView = UIView()
    open var width:  Int // 200
    open var height: Int // 45
    private var activityIndicator: UIActivityIndicatorView
    private var titleLabel = UILabel()
    open var isAwaitingTaskCompletion = false
    open var successSymbol: UIImage
    open var failureSymbol: UIImage
    open var errorSymbol:   UIImage
    open var didFinishTask = false
    
    public init() {
        self.width  = 200
        self.height = 45
        self.activityIndicator = UIActivityIndicatorView()
        self.successSymbol = UIImage(systemName: "checkmark.circle")!
        self.failureSymbol = UIImage(systemName: "x.circle")!
        self.errorSymbol   = UIImage(systemName: "wifi.exclamationmark")!
    }
    
    public init(width: Int, height: Int) {
        self.width  = width
        self.height = height
        self.activityIndicator = UIActivityIndicatorView()
        self.successSymbol = UIImage(systemName: "checkmark.circle")!
        self.failureSymbol = UIImage(systemName: "x.circle")!
        self.errorSymbol   = UIImage(systemName: "wifi.exclamationmark")!
    }
    
    public init(activityIndicator: UIActivityIndicatorView) {
        self.activityIndicator = activityIndicator
        self.width  = 200
        self.height = 45
        self.successSymbol = UIImage(systemName: "checkmark.circle")!
        self.failureSymbol = UIImage(systemName: "x.circle")!
        self.errorSymbol   = UIImage(systemName: "wifi.exclamationmark")!
    }
    
    open func hide(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1, delay: 0.25) {
                self.pillView.frame = CGRect(x: self.pillView.frame.minX, y: -300, width: self.pillView.frame.width, height: self.pillView.frame.height)
                if let completionHandler = completionHandler { completionHandler() }
            }
        }
    }
    
    // MARK: Task
    
    open func completedTask(state: Bool) {
        guard
            let titleLabel = pillView.viewWithTag(1) as? UILabel,
            let imageView  = pillView.viewWithTag(2) as? UIImageView
        else { return }
        
        imageView.image = state ? successSymbol : failureSymbol
        imageView.tintColor = state ? .green : .red
        imageView.isHidden = true
        
        UIView.transition(from: self.activityIndicator, to: imageView, duration: 0.25, options: .transitionCrossDissolve) { _ in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            imageView.isHidden = false
        }
        
        hide()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            imageView.removeFromSuperview()
            titleLabel.removeFromSuperview()
        }
        
        isAwaitingTaskCompletion = false
    }
    
    open func showTask(message: String, vcView: UIView) {
        
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
        titleLabel.tag = 1
        
        // activityIndicator
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: titleLabel.frame.maxX,
                                                                  y: 11,
                                                                  width: (pillView.frame.width - 15) -       titleLabel.frame.maxX,
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
            self.pillView.frame = CGRect(x: 100, y: UIDevice.current.hasNotch ? 45 : 25, width: self.width, height: self.height)
            self.pillView.center.x = vcView.center.x
        }
        
        vcView.addSubview(pillView)
        
        isAwaitingTaskCompletion = true
    }
    
//    public func showError(message: String, vcView: UIView) {
//        // pillView init
//        pillView.frame = CGRect(x: 100, y: -300, width: width, height: height)
//        pillView.backgroundColor = UIColor.PillboxBackgroundColor
//        pillView.layer.cornerRadius = 20
//
//        // shadow for pillView
//        pillView.layer.shadowColor = UIColor.black.cgColor
//        pillView.layer.shadowOpacity = 0.1
//        pillView.layer.shadowOffset = .zero
//        pillView.layer.shadowRadius = 10
//
//        // titleLabel
//        titleLabel = UILabel(frame: CGRect(x: 0, y: 11, width: pillView.frame.width - 40, height: 23))
//        titleLabel.text = message
//        titleLabel.textAlignment = .center
//        titleLabel.textColor = UIColor.PillboxTitleColor
//        titleLabel.tag = 1
//
//
//        let imageView = UIImageView(frame: CGRect(x: titleLabel.frame.maxX,
//                                                  y: 11,
//                                                  width: (pillView.frame.width - 15) - titleLabel.frame.maxX,
//                                                  height: 23))
//
//        imageView.isHidden = true
//        imageView.tag = 2
//        imageView.image = errorSymbol
//
//        // moving/adding into frame
//
//        pillView.addSubview(titleLabel)
//        pillView.addSubview(imageView)
//
//        vcView.addSubview(pillView)
//
//        UIView.animate(withDuration: 1) {
//            self.pillView.frame = CGRect(x: 100, y: 45, width: self.width, height: self.height)
//            self.pillView.center.x = vcView.center.x
//        }
//
//        isAwaitingTaskCompletion = true
//    }
}
