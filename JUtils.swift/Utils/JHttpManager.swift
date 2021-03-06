//
//  JHttpManager.swift
//  JUtils_swift
//
//  Created by jiangliang on 2018/3/25.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import Alamofire

open class JHttpManager {
    
    public struct Result {
        var code: Int
        var data: Any?
        var message: String
        var error: NSError?
    }
    
    open class func requestAsynchronous(url: String, method: HTTPMethod, parameters: Dictionary<String, Any>?,completion: @escaping (_ data: Result) -> ()) {
      
        var params = parameters
        if params == nil {
            params = Dictionary<String, String>()
        }
        
        #if DEBUG
            var string = "?"// "?softversion=\(Util.appVersion())&systype=ios&sysversion=\(Util.systemVersion())"
            if let ps = params {
                for key in ps.keys {
                    var value: String
                    let val = ps[key]
                    if val is NSNumber {
                        value = NSString(format: "%@", val as! NSNumber) as String
                    } else {
                        value = val as! String
                    }
                    string = string + key + "=" + value + "&"
                }
            }
        
            string = string.substring(toIndex: string.count - 1)
        
            print(url + string)
        #endif

        Alamofire.request(url, method:method, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                let result = response.result.value as! Dictionary<String, AnyObject>
                if let status = result["status"] {

                    completion(Result(code: status as! Int, data: nil, message: result["exception"] as! String, error: NSError(domain: result["exception"] as! String, code: status as! Int, userInfo: nil)))
                } else {
                    completion(Result(code:Int(truncating: result["code"] as! NSNumber), data: result["data"], message: result["message"] as! String, error: nil))
                }
            } else {
                print(response.result.error.debugDescription)

                completion(Result(code: -100001, data: nil, message: "", error: NSError(domain: "连接服务器出错", code: -100001, userInfo: nil)))
            }
        }
    }
}
