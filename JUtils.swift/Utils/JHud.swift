//
//  JHud.swift
//  JUtils_swift
//
//  Created by jiangliang on 2018/3/26.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import UIKit

let defaultTime: Float = 2.0

let imageWidth = 30.0 // 显示图片时的大小

let defaultHudWidth: CGFloat = UIScreen.main.bounds.width*2/5

// MARK: ----

open class JHud {
    public static let instance = JHud()
    
    var window: UIWindow?
    var containerView: UIView?
    var animating: Bool = false
    
    lazy var overlayView: UIControl? = {
        var overView = UIControl(frame: UIScreen.main.bounds)
        overView.isUserInteractionEnabled = true
        overView.backgroundColor = UIColor.colorWith(hex: "000000", alpha: 0.4)
        return overView
    }()
    
    lazy var hudView: JHudView = {
        let hudV = JHudView()
        hudV.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return hudV
    }()
    
    private init() {
        self.window = UIApplication.shared.keyWindow
    }
    
    // 简单的显示
    public class func show(content: String) {
        self.show(image: nil, content: content, withTime: defaultTime, lock: false, inView: nil)
    }
    
    // 是否禁止操作  lock 锁住操作
    public class func show(content: String, lock: Bool) {
        self.show(image: nil, content: content, withTime: defaultTime, lock: lock, inView: nil)
    }
    
    // 规定时间
    public class func show(content: String, withTime: Float) {
        self.show(image: nil, content: content, withTime: withTime, lock: false, inView: nil)
    }
    
    //
    public class func show(content: String, withTime: Float, inView: UIView) {
        self.show(image: nil, content: content, withTime: withTime, lock: false, inView: inView)
        
    }
    
    // 图片
    public class func show(image: UIImage) {
        self.show(image: image, content: nil, withTime: defaultTime, lock: false, inView: nil)
    }
    
    public class func show(image: UIImage, content: String, withTime: Float) {
        self.show(image: image, content: content, withTime: withTime, lock: false, inView: nil)
    }
    
    public class func show(image: UIImage?, content: String?, withTime: Float, lock: Bool, inView: UIView?) {
        self.instance.show(image: image, activity: false, content: content, withTime: withTime, lock: lock, inView: inView)
    }
    
    
    // 菊花
    public class func showHudView(inView: UIView, lock: Bool) {
        self.instance.show(image: nil, activity: true, content: nil, withTime: -1, lock: lock, inView: inView)
    }
    
    public class func hide() {
        self.instance.hide()
    }
    
    // MARK: ----- instance method
    // 私有方法
    private func show(image: UIImage?, activity: Bool, content: String?, withTime: Float, lock: Bool, inView: UIView?) {
        if let _ = inView {
            self.containerView = inView
        } else {
            self.containerView = self.window
        }
        if lock {
            self.containerView?.addSubview(self.overlayView!)
        }
        if !(self.containerView?.subviews.contains(self.hudView))! {
            self.containerView?.addSubview(self.hudView)
        }
        self.hudView.layoutView(image: image, content: content, activity: activity)
        
        self.hudView.center = (self.containerView?.center)!
        
        self.show()
        if withTime > -1 {
            var time = withTime
            if time == 0 {
                time = defaultTime
            }
           
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(time)){
                self.hide()
            }
        }
    }
    
    private func show() {
        hudView.alpha = 0
        overlayView?.alpha = 0
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.hudView.alpha = 1
            self.overlayView?.alpha = 1
        }, completion: { finished in
        })
    }
    
    private func hide() {
        if let hudActivityView = self.hudView.hudActivityView {
            hudActivityView.stopAnimating()
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn, .allowUserInteraction], animations: {
            self.hudView.alpha = 0
            self.overlayView?.alpha = 0
            
        }, completion: { finished in
            self.animating = false
            self.hudView.removeFromSuperview()
            self.overlayView?.removeFromSuperview()
        })
    }
}


class JHudView: UIView {
    
    lazy var hudImageView: UIImageView? = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageWidth))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var hudContentLabel: UILabel? = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var hudActivityView: UIActivityIndicatorView? = {
        let hudView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        hudView.autoresizingMask = [.flexibleTopMargin, .flexibleHeight]
        return hudView
    }()
    
    func layoutView(image: UIImage?, content: String?, activity: Bool) {
        if image != nil && activity == true {
            assert(false, "图片和菊花不能同时出现")
        }
        var contentSize = CGSize.zero
        if let text = content {
            contentSize = text.size(font: (hudContentLabel?.font)!, constrainedSize: CGSize(width: defaultHudWidth - 20, height: CGFloat.greatestFiniteMagnitude))
        }
        
        hudContentLabel?.text = content
        
        if image != nil {
            hudImageView?.isHidden = false
            hudActivityView?.isHidden = true
            
            hudImageView?.image = image
            hudImageView?.center = CGPoint(x: defaultHudWidth/2, y: 20+(hudImageView?.height)!/2);
            
            hudContentLabel?.top = (hudImageView?.bottom)! + 20
            
        }else if(activity) {
            hudActivityView?.isHidden = false
            hudImageView?.isHidden = true
            
            hudActivityView?.center = CGPoint(x: defaultHudWidth/2, y: 20+(hudActivityView?.height)!/2);
            hudActivityView?.startAnimating()
            hudContentLabel?.top = (hudActivityView?.bottom)! + 20
        } else {
            hudActivityView?.isHidden = true
            hudImageView?.isHidden = true
            
            hudContentLabel?.top = 20
        }
        
        hudContentLabel?.height = contentSize.height
        hudContentLabel?.width = defaultHudWidth - 20
        hudContentLabel?.left = 5
        
        self.width = defaultHudWidth;

        if contentSize.height == 0 {
            self.height = defaultHudWidth
            hudImageView?.center = CGPoint(x: defaultHudWidth/2, y: defaultHudWidth/2);
            hudActivityView?.center = CGPoint(x: defaultHudWidth/2, y: defaultHudWidth/2);

        } else {
            self.height = (hudContentLabel?.bottom)! + 20
        }
        
        if !self.subviews.contains(hudImageView!) {
            self.addSubview(hudImageView!)
            self.addSubview(hudActivityView!)
            self.addSubview(hudContentLabel!)
        }
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}
