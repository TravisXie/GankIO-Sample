//
//  GankNews.swift
//  Gank
//
//  Created by Blake on 11/24/16.
//  Copyright © 2016 Travis. All rights reserved.
//  新闻模型

import UIKit

class GankNews: NSObject {
    
    var _id: String?
    
    var createdAt: String? {
        didSet {
            createdAt = createdAt?.publishTime()
        }
    }
    
    var desc: String?
    
    var images: [String]?
    
    var publishedAt: String?
    
    var source: String?
    
    var type: String?
    
    var url: String?
    
    var used: Bool?
    
    var who: String? {
        didSet {
            who = who != nil ? "via" + " \(who!)" : ""
        }
    }
    
    init(withDict dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) { }
}

extension String {
    func publishTime() -> String {
        var newtimeStr = self
        if let range = self.rangeOfString("T") {
            let index = range.startIndex
            newtime = newtimeStr.substringToIndex(index)
            return newtimeStr
        }
        return newtimeStr
    }
}

