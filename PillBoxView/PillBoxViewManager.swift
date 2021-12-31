//
//  PillBoxViewManager.swift
//  PillBoxView
//
//  Created by Jacob Trentini on 12/30/21.
//

import UIKit

class PillBoxViewManager {
    var pillView = UIView()
    private let width = 200
    private let height = 45
    private var activityIndicator = UIActivityIndicatorView()
    private var titleLabel = UILabel()
    
    public var didFinishTask: Bool? {
        willSet {
            if let result = newValue {
                guard
                    let titleLabel = pillView.viewWithTag(1) as? UILabel,
                    let imageView  = pillView.viewWithTag(2) as? UIImageView
                else { return }
                
                imageView.image = UIImage(systemName: result ? "checkmark.circle" : "x.circle")
                imageView.tintColor = result ? .green : .red
                imageView.isHidden = true
                
                UIView.transition(from: self.activityIndicator, to: imageView, duration: 0.25, options: .transitionCrossDissolve) { _ in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    imageView.isHidden = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIView.animate(withDuration: 1, delay: 0.25) {
                        self.pillView.frame = CGRect(x: self.pillView.frame.minX, y: -300, width: self.pillView.frame.width, height: self.pillView.frame.height)
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    imageView.removeFromSuperview()
                    titleLabel.removeFromSuperview()
                }
            }
        }
    }
    
    func show(title: String, vcView: UIView) {
        
        // pillView init
        pillView.frame = CGRect(x: 100, y: -300, width: width, height: height)
        pillView.backgroundColor = UIColor(named: "PillBoxBackgroundColor")
        pillView.layer.cornerRadius = 20
        
        // shadow for pillView
        pillView.layer.shadowColor = UIColor.black.cgColor
        pillView.layer.shadowOpacity = 0.1
        pillView.layer.shadowOffset = .zero
        pillView.layer.shadowRadius = 10
        
        // titleLabel
        titleLabel = UILabel(frame: CGRect(x: 0, y: 11, width: pillView.frame.width - 40, height: 23))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(named: "PillBoxTitleColor")
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
            self.pillView.frame = CGRect(x: 100, y: 45, width: self.width, height: self.height)
            self.pillView.center.x = vcView.center.x
        }
        
        vcView.addSubview(pillView)
    }
}
