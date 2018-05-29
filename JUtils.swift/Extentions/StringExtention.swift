//
//  StringExtention.swift
//  JUtils_swift
//
//  Created by jiangliang on 2018/4/21.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    func substring(fromIndex: Int) -> String {
        if fromIndex >= self.count {
            return ""
        }
        return String(self[self.index(self.startIndex, offsetBy: fromIndex)..<self.endIndex])
    }
    
    func substring(toIndex: Int) -> String {
        if toIndex >= self.count {
            return self
        }
        return String(self[self.startIndex..<self.index(self.startIndex, offsetBy: toIndex)])
    }
}

public extension String {
    func urlEncode() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    func urlDecode() -> String {
        return self.removingPercentEncoding!
    }
    
    func size(font: UIFont, constrainedSize: CGSize) -> CGSize {
        let nString = self as NSString
        
        return nString.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil).size
    }
}
