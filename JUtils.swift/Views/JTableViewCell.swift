//
//  JTableViewCell.swift
//  JUtils_swift
//
//  Created by jiangliang on 2018/4/6.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

open class JTableViewCell : UITableViewCell {

    public struct PTableViewCellStyle: OptionSet {
        public let rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        public static let `default` = PTableViewCellStyle(rawValue: 1 << 0)
        public static let icon = PTableViewCellStyle(rawValue: 1 << 1)
        public static let description = PTableViewCellStyle(rawValue: 1 << 2)
        public static let content = PTableViewCellStyle(rawValue: 1 << 3)
        public static let arrow = PTableViewCellStyle(rawValue: 1 << 4)
    }
    
    public var iconImageView: UIImageView? {
        let imgV = UIImageView(frame: CGRect(x: left, y: (self.height - 20.0)/2.0, width: 20.0, height: 20.0))
        imgV.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        imgV.layer.masksToBounds = true
        imgV.contentMode = .scaleAspectFill
        return imgV
    }
    public var leftLabel: UILabel? {
        let label = UILabel(frame: CGRect(x: left, y: 0, width: 0, height: self.height))
        label.font = UIFont.systemFont(ofSize: 14)
        label.autoresizingMask = .flexibleHeight
        label.textColor = UIColor.colorWith(hex: "333333", alpha: 1)
        return label
    }
    public var rightLabel: UILabel? {
        let rLabel = UILabel(frame: CGRect(x: left, y: 0, width: 0, height: self.height))
        rLabel.font = UIFont.systemFont(ofSize: 14)
        rLabel.autoresizingMask = .flexibleHeight
        rLabel.textColor = UIColor.colorWith(hex: "666666", alpha: 1)
        rLabel.textAlignment = .right
        rLabel.numberOfLines = 0
        return rLabel
    }
    var arrowView: JArrowView?
    
    public init(style: PTableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        if style.contains(.default) {
            return
        }
        
        var left: CGFloat = 16.0
        
        if style.contains(.icon) {
            self.contentView.addSubview(iconImageView!)
            left += 20 + 10
        }
        
        if style.contains(.description) {
            
            self.contentView.addSubview(leftLabel!)
            
            leftLabel?.addObserver(self, forKeyPath: "text", options: .new, context: nil)
            
            left += leftLabel!.right + 20
        }
        
        if style.contains(.arrow) {
            arrowView = JArrowView(frame: CGRect(x: UIScreen.main.bounds.width - 16 - 8, y: (self.height - 12)/2.0, width: 8, height: 12))
            arrowView?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
            self.contentView.addSubview(arrowView!)
        }
        
        if style.contains(.content) {
            
            if let v = arrowView {
                rightLabel?.width = v.left - leftLabel!.right - 20
            } else {
                rightLabel?.width = UIScreen.main.bounds.width - 16 - leftLabel!.right - 20
            }
            self.contentView.addSubview(rightLabel!)
        }   
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as! UILabel) == leftLabel {

            let width = NSString(string: leftLabel!.text!).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: leftLabel!.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: leftLabel!.font], context: nil).width
            leftLabel?.width = width
            rightLabel?.left = leftLabel!.right + 10
  
            if let v = arrowView {
                rightLabel?.width = v.left - leftLabel!.right - 20
            } else {
                rightLabel?.width = UIScreen.main.bounds.width - 16 - leftLabel!.right - 10
            }
        }
    }
    
    open class func cellHeight(with: Any?) -> CGFloat {
        return 50
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JArrowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint.zero)
        bezierPath.addLine(to: CGPoint(x: self.width, y: self.height/2.0))
        bezierPath.addLine(to: CGPoint(x: 0.0, y: self.height))
        
        let shaperLayer = CAShapeLayer()
        shaperLayer.fillColor = UIColor.clear.cgColor
        shaperLayer.lineWidth = 1
        shaperLayer.strokeColor = UIColor(white: 0.7, alpha: 0.6).cgColor
        shaperLayer.path = bezierPath.cgPath
        self.layer.addSublayer(shaperLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
