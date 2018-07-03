//
//  UIView+ActivityIndicator.swift
//  Mouse
//
//  Created by Amir Zigangarayev on 07.12.2017.
//  Copyright © 2017 Mouse. All rights reserved.
//

import UIKit

extension UIView {
    private var hudView: HudView? {
        get {
            for case let subview as HudView in subviews {
                return subview
            }
            return nil
        }
    }
    
    func startShowingActivityIndicator(with backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.75)) {
        hudView?.removeFromSuperview()
        
        let hud = HudView()
        hud.backgroundColor = backgroundColor
        hud.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hud)
        
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: hud, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: hud, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: hud, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: hud, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func stopShowingActivityIndicator() {
        hudView?.removeFromSuperview()
    }
}

private class HudView: UIView {
    
    var activityIndicator: UIActivityIndicatorView?
    
    init() {
        super.init(frame: .zero)
        prepareAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareAppearance()
    }
    
    private func prepareAppearance() {
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.activityIndicatorViewStyle = .whiteLarge
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator?.startAnimating()
        
        addSubview(activityIndicator!)
        
        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
    }
}
