//
//  NetRequester.swift
//  BangumiKit
//
//  Created by kukushi on 11/8/14.
//  Copyright (c) 2014 kukushiStudio. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum NetRequesterErrorType: Int {
    case Success
    case NoUpdate
    case Unreachable
    case ParseFail
}

public typealias BangumisFetcherCallback = (bangumis:[Bangumi]!, errorType:NetRequesterErrorType) -> Void
public typealias SPFetcherCallback = (episodes:[Episode]!, errorType:NetRequesterErrorType) -> Void
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
    private let host = "http://api.bilibili.com"
    private class var BilibiliAPIkey: String {
        return "0f38c1b83b2de0a0"
    }
    
    // MARK: Fetch Bangumis
    
    class func fetchBangumis(callback: BangumisFetcherCallback) {
        let session = NSURLSession.sharedSession()
        let bangumisFetchingURL = NSURL(string: "http://www.bilibili.tv/index/bangumi.json")
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
    
    // MARK: Fetch SP
    class func fetchSPEpisodes(#spID: Int, callback: SPFetcherCallback) {
        var parameters : [String: AnyObject] = [
            "appkey": BilibiliAPIkey,
            "bangumi": 1,
            "platform": "ios",
            "season_id": 0,
            "spid": spID,
            "type": "",
        ]
        
        Alamofire.request(.GET, "123", parameters: parameters).response { (request, repsonse, data, error) -> Void in
            let JSONData = JSON(data: data as NSData)
            if let list = JSONData["list"].array {
                var episodes = [Episode]()
                for dict in list {
                    episodes.append(Episode(dict: dict))
                }
                callback(episodes: episodes, errorType: .Success)
            }
            else {
                
            }
        }
        
        //}
    }
    
//    func fetchSearchResult(keyword: String, callback: )
}

// MARK: Implementation

extension NetRequester {
    
    private class func parseBangumis(data: NSData) -> [Bangumi]? {
        /*
        let JSONData = JSON(data: data)
        var bangumis = [Bangumi]()
        if let array = JSONData.array {
            for dict in array {
                bangumis.append(Bangumi(dict: dict))
            }
            return bangumis
        }
        else {
//            Alamofire.Manager.sharedInstance.request(<#method: Method#>, <#URLString: URLStringConvertible#>, parameters: <#[String : AnyObject]?#>, encoding: <#ParameterEncoding#>)
            return nil
        }
*/
        return nil
    }
}