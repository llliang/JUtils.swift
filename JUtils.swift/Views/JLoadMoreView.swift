//
//  JLoadMoreView.swift
//  JUtils_swift
//
//  Created by jiangliang on 2018/4/4.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

open class JLoadMoreView: JTableViewCell {
    
    var stateLabel: UILabel?
    
    override init(style: PTableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        stateLabel = UILabel(frame: self.bounds)
        stateLabel?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stateLabel?.font = UIFont.systemFont(ofSize: 12)
        stateLabel?.textAlignment = .center
        stateLabel?.textColor = UIColor.colorWith(hex: "333333", alpha: 1)
        self.contentView.addSubview(stateLabel!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
