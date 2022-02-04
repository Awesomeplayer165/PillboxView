//
//  PillView.swift
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

public class PillView {
    
    public var pillView = UIView()
    public var width:  Int
    public var height: Int
    private var activityIndicator: UIActivityIndicatorView
    private var titleLabel = UILabel()
    public var isAwaitingTaskCompletion = false
    public var successSymbol: UIImage
    public var failureSymbol: UIImage
    public var errorSymbol:   UIImage
    public var didFinishTask = false
    public var vcView: UIView?
    
    public var showType: PillboxShowType?
    
    public static var activePillBoxViews = Set<PillView>()
    
    public init() {
        self.width  = 200
        self.height = 45
        self.activityIndicator = UIActivityIndicatorView()
        self.successSymbol = UIImage(systemName: "checkmark.circle")!
        self.failureSymbol = UIImage(systemName: "x.circle")!
        self.errorSymbol   = UIImage(systemName: "wifi.exclamationmark")!
        self.showType = nil
    }
    
    public init(width: Int, height: Int) {
        self.width  = width
        self.height = height
        self.activityIndicator = UIActivityIndicatorView()
        self.successSymbol = UIImage(systemName: "checkmark.circle")!
        self.failureSymbol = UIImage(systemName: "x.circle")!
        self.errorSymbol   = UIImage(systemName: "wifi.exclamationmark")!
        self.showType = nil
    }
    
    public init(activityIndicator: UIActivityIndicatorView) {
        self.activityIndicator = activityIndicator
        self.width  = 200
        self.height = 45
        self.successSymbol = UIImage(systemName: "checkmark.circle")!
        self.failureSymbol = UIImage(systemName: "x.circle")!
        self.errorSymbol   = UIImage(systemName: "wifi.exclamationmark")!
        self.showType = nil
    }
    
    open func hide(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 1, delay: 0.25) {
                self.pillView.frame = CGRect(x: self.pillView.frame.minX, y: -300, width: self.pillView.frame.width, height: self.pillView.frame.height)
                if let completionHandler = completionHandler { completionHandler() }
            }
        }
    }
    
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
            
            hide()
            
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
            self.hide()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            imageView.removeFromSuperview()
            self.titleLabel.removeFromSuperview()
            self.showType = nil
        }
    }
}

extension PillView: Hashable {
    public static func == (lhs: PillView, rhs: PillView) -> Bool {
           lhs.pillView                 == rhs.pillView
        && lhs.width                    == rhs.width
        && lhs.height                   == rhs.height
        && lhs.activityIndicator        == rhs.activityIndicator
        && lhs.titleLabel               == rhs.titleLabel
        && lhs.isAwaitingTaskCompletion == rhs.isAwaitingTaskCompletion
        && lhs.successSymbol            == rhs.successSymbol
        && lhs.failureSymbol            == rhs.failureSymbol
        && lhs.errorSymbol              == rhs.errorSymbol
        && lhs.didFinishTask            == rhs.didFinishTask
        && lhs.vcView                   == rhs.vcView
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(pillView)
        hasher.combine(width)
        hasher.combine(height)
        hasher.combine(activityIndicator)
        hasher.combine(titleLabel)
        hasher.combine(isAwaitingTaskCompletion)
        hasher.combine(successSymbol)
        hasher.combine(failureSymbol)
        hasher.combine(errorSymbol)
        hasher.combine(didFinishTask)
        hasher.combine(vcView)
    }
}
