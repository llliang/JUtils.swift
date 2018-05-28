//
//  JNavigationController.swift
//  JUtils_swift
//
//  Created by jiangliang on 2018/4/2.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class JNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.colorWith(hex: "333333", alpha: 1), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
//        self.navigationBar.barTintColor = UIColor.tintColor
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return self.viewControllers.count > 1
    }
}
