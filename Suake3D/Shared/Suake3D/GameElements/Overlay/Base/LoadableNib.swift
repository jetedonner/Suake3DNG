//
//  LoadableNib.swift
//  Suake3D
//
//  Created by Kim David Hauser on 10.05.20.
//  Copyright © 2020 DaVe Inc. All rights reserved.
//

import Foundation
import SceneKit

protocol LoadableNib {
    var contentView: NSView! { get }
}

extension LoadableNib where Self: NSView {
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = NSNib(nibNamed: .init(String(describing: type(of: self))), bundle: bundle)!
        _ = nib.instantiate(withOwner: self, topLevelObjects: nil)
        
        let contentConstraints = contentView.constraints
        contentView.subviews.forEach({ addSubview($0) })
        
        for constraint in contentConstraints {
            let firstItem = (constraint.firstItem as? NSView == contentView) ? self : constraint.firstItem
            let secondItem = (constraint.secondItem as? NSView == contentView) ? self : constraint.secondItem
            addConstraint(NSLayoutConstraint(item: firstItem as Any, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant))
        }
    }
}
