//
//  NetRequester.swift
//  BangumiKit
//
//  Created by kukushi on 11/8/14.
//  Copyright (c) 2014 kukushiStudio. All rights reserved.
//

import Foundation
import Alamofire

public enum NetRequesterErrorType: Int {
    case Success
    case NoUpdate
    case Unreachable
    case ParseFail
}

public typealias BangumisFetcherCallback = (bangumis:[Bangumi]!, errorType:NetRequesterErrorType) -> Void
//public typealias BangumiSearchResultCallback
/**
*  Net
*/
class NetRequester {
    
    // MARK: Singleton
    
    class var sharedRequester: NetRequester {
        struct Static {
            static let sharedRequester = NetRequester()
        }
        return Static.sharedRequester
    }
    
    // MARK:
    private let bangumisFetchingURL = NSURL(string: "http://www.bilibili.tv/index/bangumi.json")
    private let BilibiliAPIkey = "0f38c1b83b2de0a0"
    
    // MARK: Fetch Bangumis
    
    func fetchBangumis(callback: BangumisFetcherCallback) {
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(bangumisFetchingURL!, completionHandler: { (data, response, error) -> Void in
            var cachedBangumis: [Bangumi]!
            var errorType: NetRequesterErrorType
            if response != nil {
                if let bangumis = self.parseBangumis(data) {
                    cachedBangumis = bangumis
                    errorType = .Success
                }
                else {
                    errorType = .ParseFail
                }
            } else {
                println("\(error)")
                errorType = .Unreachable
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                callback(bangumis: cachedBangumis, errorType: errorType)
            })
            
        }).resume()
    }
    
//    func fetchSearchResult(keyword: String, callback: )
}

// MARK: Implementation

extension NetRequester {
    
    private func parseBangumis(data: NSData) -> [Bangumi]? {
        if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as? [AnyObject] {
            var bangumis = [Bangumi]()
            for dict in jsonArray {
                if let theDict = dict as? [String: AnyObject] {
                    bangumis.append(Bangumi(dict: theDict))
                }
            }
            return bangumis
        }
        else {
//            Alamofire.Manager.sharedInstance.request(<#method: Method#>, <#URLString: URLStringConvertible#>, parameters: <#[String : AnyObject]?#>, encoding: <#ParameterEncoding#>)
            return nil
        }
    }
}