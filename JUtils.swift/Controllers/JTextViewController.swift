//
//  JTextViewController.swift
//  JUtils_swift
//
//  Created by jiangliang on 2018/4/6.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

open class JTextViewController: UIViewController, UITextViewDelegate {

    var maxCount: Int = 0
    
    var indicatingLabel: UILabel?
    
    var placeholder: String? {
        didSet {
            textView?.placeholder = placeholder
        }
    }
    
    var font = UIFont.systemFont(ofSize: 14)
    
    var text: String? {
        didSet {
            textView?.text = text
        }
    }
    
    private var textView: JPlaceholderTextView?
    
    private var countLabel: UILabel?
    
    typealias DidBlock = (_ text: String) -> ()
    
    var didBlock: DidBlock?
    
    func didText(block: @escaping DidBlock) {
        didBlock = block
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        textView = JPlaceholderTextView(frame: CGRect(x: 0, y: 10, width: self.view.width, height: 120))
        textView?.font = font
        textView?.backgroundColor = UIColor.white
        textView?.contentInset = UIEdgeInsetsMake(10, 0, 20, 10)
        textView?.returnKeyType = UIReturnKeyType.done
        textView?.delegate = self
        textView?.placeholder = placeholder
        textView?.text = text
        self.view.addSubview(textView!)
        
        if maxCount > 0 {
            indicatingLabel = UILabel(frame: CGRect(x: 0, y: textView!.height - 20, width: textView!.width - 10, height: 20))
            indicatingLabel?.font = font
            indicatingLabel?.textAlignment = .right
            indicatingLabel?.textColor = UIColor.colorWith(hex: "333333", alpha: 1)
            self.view.addSubview(indicatingLabel!)
            indicatingLabel?.text = "\((maxCount*2 - self.lengthOfBytes(text: textView?.text))/2)"
        }
    }

    public func  textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            didBlock!(textView.text)
            self.navigationController?.popViewController(animated: true)
            return false
        }
        if textView.markedTextRange == nil {
            if  self.lengthOfBytes(text: textView.text) + self.lengthOfBytes(text: text) > maxCount*2 && text != "" {
                return false
            }
        } else {
            if self.lengthOfBytes(text: String((textView.text?.dropLast(range.length))!)) + self.lengthOfBytes(text: text) > maxCount*2 {
                return false
            }
        }
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
   
        indicatingLabel?.text = "\((maxCount*2 - self.lengthOfBytes(text: textView.text))/2)"
    }
    
    func lengthOfBytes(text: String?) -> Int {
        if text == nil {
            return 0
        }
        var count = 0
        for char in text! {
            count += String(char).lengthOfBytes(using: .utf8)==3 ? 2 : 1
        }
        return count
    }
    
}
