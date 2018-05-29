//
//  UIBarItemExtension.swift
//  JUtils_swift
//
//  Created by jiangliang on 2018/4/8.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import UIKit

public extension UIBarButtonItem {
    
    enum PBarButtonItemStyle {
        case left
        case center
        case right
    }
    
    convenience init(title: String, style: PBarButtonItemStyle, target: Any, action: Selector) {
        
        let t = title as NSString
        let width: CGFloat = t.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 44.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil).width
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: max(50, width), height: 44))
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.colorWith(hex: "333333", alpha: 1), for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        switch style {
        case .left:
            btn.contentHorizontalAlignment = .left
        case .center:
            btn.contentHorizontalAlignment = .center
        default:
            btn.contentHorizontalAlignment = .right
        }
        self.init(customView: btn)
    }
}

