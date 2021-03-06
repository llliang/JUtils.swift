//
//  JDataModel.swift
//  JUtils_swift
//
//  Created by jiangliang on 2018/4/2.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit
import Alamofire

open class JDataModel<Element: JEntity, Type>: NSObject {
    open var code: NSInteger?
    open var message: String?
    open var data: Type?
    open var cacheKey: String?
    
    public var loading: Bool = false
    public var canLoadMore: Bool = false
    public var isReload: Bool = true {
        didSet {
            if isReload {
                self.page = 1
            }
        }
    }
    
    public var limited: NSInteger = 20
    public var page: NSInteger = 1
    
    public var method: HTTPMethod = .get
    public var url: String?
    public var params = Dictionary<String, Any>()
    
    public var itemCount: NSInteger = 0
    
    public typealias StartBlock = () -> ()
    public typealias FinishedBlock = (_ data: Type?, _ error: NSError?) -> ()
    
    open func load(start: StartBlock, finished: @escaping FinishedBlock) {
        if !loading {
            start()
            loading = true
            
            params["page"] = self.page
            params["limited"] = self.limited
            
            JHttpManager.requestAsynchronous(url: url!, method: method, parameters: params, completion: { result in
                
                self.loading = false
                if result.error == nil {
                    if result.code == 200 {
                        self.parse(source: result.data as AnyObject)
                        finished(self.data, nil)
                    } else {
                        finished(nil, result.error)
                    }
                } else {
                    finished(nil, result.error)
                }
                
                self.isReload = false
            })
        }
    }
    
    open func parse(source: AnyObject?) {
        if source is Array<Any> {
            
            let array = source as! Array<Any>
            
            canLoadMore = array.count >= limited
            var tmpData = self.data as? [Element]
            if tmpData == nil {
                tmpData = [Element]()
            }
            let tmp: [Element] = array.map({ (item) -> Element in
                return Element.toEntity(data: item)
            })
            
            if !isReload {
                tmpData?.append(contentsOf: tmp)
            } else {
                tmpData = tmp
            }
            self.data = tmpData as? Type
            
            if let key = cacheKey {
               let _ = JCacheManager.instance.setCache(cache: tmpData!, forKey: key)
            }
            
            itemCount = (tmpData?.count)!
            page += 1
        } else if source is Dictionary<String, Any> {
            let entity = Element.toEntity(data: source)
            self.data = entity as? Type
            if let key = cacheKey {
                let _ = JCacheManager.instance.setCache(cache: entity, forKey: key)
            }
            itemCount = 0
        } else {
            self.data = nil
            itemCount = 0
        }
    }
    
    public func item(ofIndex: NSInteger) -> Element {
        if data is Array<JEntity> {
            let tmp = data as! Array<Element>
            return tmp[ofIndex]
        } else {
            return data as! Element
        }
    }
    
    required override public init() {
        
    }
}
