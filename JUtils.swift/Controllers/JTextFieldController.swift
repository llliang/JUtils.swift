//
//  JTextFieldController.swift
//  JUtils_swift
//
//  Created by jiangliang on 2018/4/6.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class JTextFieldController: UIViewController, UITextFieldDelegate {
    
    var maxCount: Int = 0
    
    var placeholder: String? {
        didSet {
            textField?.placeholder = placeholder
        }
    }
    
    var text: String? {
        didSet {
            textField?.text = text
        }
    }
    
    private var textField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        let backView = UIView(frame: CGRect(x: 0, y: 10, width: self.view.width, height: 44))
        backView.backgroundColor = UIColor.tintColor
        self.view.addSubview(backView)
        
        textField = UITextField(frame: CGRect(x: 16, y: 0, width: backView.width - 32, height: backView.height))
        textField?.placeholder = placeholder
        textField?.text = text
        textField?.font = UIFont.systemFont(ofSize: 14)
        textField?.textColor = UIColor.titleColor
        textField?.clearButtonMode = UITextFieldViewMode.whileEditing
        textField?.becomeFirstResponder()
        textField?.returnKeyType = UIReturnKeyType.done
        textField?.enablesReturnKeyAutomatically = true
        backView.addSubview(textField!)
        
        textField?.delegate = self
    }
    
    typealias DidBlock = (_ text: String) -> ()
    
    var didBlock: DidBlock?
    
    func didText(block: @escaping DidBlock) {
        didBlock = block
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.markedTextRange == nil {
            if self.lengthOfBytes(text: textField.text) + self.lengthOfBytes(text: string) > maxCount*2 && string != "" {
                return false
            }
        } else {
            if self.lengthOfBytes(text: String((textField.text?.dropLast(range.length))!)) + self.lengthOfBytes(text: string) > maxCount*2 {
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        didBlock!(textField.text!)
        self.navigationController?.popViewController(animated: true)
        return true
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
