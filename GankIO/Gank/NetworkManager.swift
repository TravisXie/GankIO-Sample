//
//  NetworkManager.swift
//  Gank
//
//  Created by Blake on 11/24/16.
//  Copyright © 2016 Travis. All rights reserved.
//  处理网络请求

import Foundation
import Alamofire

public enum newsType {
    case Android
    case iOS
    case webFrontEnd
    
    var url: String {
        switch self {
        case Android:
            return "http://gank.io/api/data/Android/20/"
        case iOS:
            return "http://gank.io/api/data/iOS/20/"
        case webFrontEnd:
            return "http://gank.io/api/data/%E5%89%8D%E7%AB%AF/20/"
        }
    }
}

class NetworkManager {
    
    class var shareManager: NetworkManager {
        
        struct singleton {
            static let instance = NetworkManager()
        }
        return singleton.instance
    }
    
    typealias newsHandler =  ([GankNews]?) -> Void
    
    func fetchGankNewsWithNewType(type: newsType, page: Int = 1, news: newsHandler?) {
        let url = type.url + "\(page)"
        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON).validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let value):
                    if let newsArray = value["results"] as? [[String: AnyObject]]{
                        let gankNews = newsArray.map { GankNews(withDict: $0) }
                        news!(gankNews)
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
}