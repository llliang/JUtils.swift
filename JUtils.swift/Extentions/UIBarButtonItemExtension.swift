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
    
    public enum PBarButtonItemStyle {
        case left
        case center
        case right
    }
    
    convenience init(title: String, titleColor: UIColor, style: PBarButtonItemStyle, target: Any, action: Selector) {
        
        let t = title as NSString
        let width: CGFloat = t.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 44.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil).width
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: max(50, width), height: 44))
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(titleColor, for: .normal)
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
    
    convenience init(image: UIImage, style: PBarButtonItemStyle, target: Any, action: Selector) {
        
        let width = image.size.width*34/image.size.height
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 5, width: width, height: 34))
        
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let control = UIControl(frame: CGRect(x: 0, y: 0, width: max(50, width), height: 44))
        control.addSubview(imageView)
        control.addTarget(target, action: action, for: .touchUpInside)
        
        switch style {
        case .left:
            imageView.left = 0
        case .center:
            imageView.center = CGPoint(x: control.width/2, y: control.height/2)
        default:
            imageView.left = control.width - imageView.width
        }
        self.init(customView: control)
    }
}

