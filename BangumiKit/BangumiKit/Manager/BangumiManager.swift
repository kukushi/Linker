//
//  BangumiManager.swift
//  BangumiKit
//
//  Created by kukushi on 9/9/14.
//  Copyright (c) 2014 kukushi. All rights reserved.
//

import Foundation
import UIKit.UIApplication

enum BangumiNotificationKey: String {
    case isSingle = "BangumiNotificationKeyIsSingle"
    case Data = "BangumiNotificationKeyData"
}

public class BangumiManager {
    
    private var shouldSaveStarBangumiData = false
    private var shouldSaveBangumiData = false
    private var observedSPList: [String]!
    
    
    
    /// keep the starred bangumis' name
    private var starredBangumisList = NSHashTable(options: NSPointerFunctionsWeakMemory)
    
    private var bangumis: [Bangumi]! {
        didSet {
            shouldSaveBangumiData = true
        }
    }
    
    public typealias BangumiBackgroundFetch = (fetchResult: UIBackgroundFetchResult) -> Void
    public typealias SPBackgroundFetch = (fetchResult: UIBackgroundFetchResult) -> Void
    
    // MARK: Singleton
    
    public class var sharedManager: BangumiManager {
        struct Static {
            static let bangumiManager = BangumiManager()
        }
        
        return Static.bangumiManager
    }
    
    // MARK: Initalization
    
    init() {
        registerNotifications()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Background Fetch
    
    /**
    A method used to work with background fetch. Fetch bangumis data from net and compare it with the cached data.
    If different, a local notification'll be fired.
    
    :param: backgroundFetcher
    */
    public func checkBangumisUpdate(#bangumiBackrgoundFetcher: BangumiBackgroundFetch) {
        NetRequester.fetchBangumis { (bangumis, errorType) -> Void in
            if errorType == .Success {
                if self.bangumis == nil {
                    self.retriveBangumis()
                }
                
                if self.bangumis != nil {
                    let bangumi = self.bangumis.first
                    let index = find(bangumis, bangumi!)
                    // if the positon of the first original bangumi is positive, there is a update
                    var firstBangumi: Bangumi!
                    var starredBangumiCount = 0
                    if index > 0 {
                        for i in 0..<index! {
                            let bangumiAtIndex = bangumis[i]
                            if self.isStarred(bangumiAtIndex) {
                                ++starredBangumiCount
                                firstBangumi = bangumiAtIndex
                            }
                        }
                        
                        if starredBangumiCount > 0 {
                            self.scheduleNotification(bangumi: firstBangumi, isSingle: starredBangumiCount == 1)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                bangumiBackrgoundFetcher(fetchResult: .NewData)
                            })
                        }
                        self.bangumis = bangumis;
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            bangumiBackrgoundFetcher(fetchResult: .NoData)
                        })
                    }
                }
            }
        }
    }
    
    
    public func checkSPUpdate(#SPBackgroundFetcher: SPBackgroundFetch) {
        for spID in observedSPList {
            
        }
    }
    
    // MARK: Star Management
    
    public func unstar(bangumi: Bangumi) {
        shouldSaveStarBangumiData = true
        starredBangumisList.removeObject(bangumi.name)
    }
    
    public func star(bangumi: Bangumi) {
        shouldSaveStarBangumiData = true
        starredBangumisList.addObject(bangumi.name)
    }
    
    public func isStarred(bangumi: Bangumi) -> Bool {
        return starredBangumisList.containsObject(bangumi.name as String)
    }
    
    public func starredBangumis() -> [Bangumi] {
        var allStarredBangumis = [Bangumi]()
        for bangumi in bangumis {
            if isStarred(bangumi) {
                allStarredBangumis.append(bangumi)
            }
        }
        return allStarredBangumis
    }
    
    func changeStarState(bangumi: Bangumi) -> Bool {
        shouldSaveStarBangumiData = true
        if isStarred(bangumi) {
            unstar(bangumi)
            return false
        }
        else {
            star(bangumi)
            return true
        }
    }
    
    // MARK: Bangumi
    
    public func fetchBangumis(callback: BangumisFetcherCallback) {
        if let bangumis = fetchCachedBangumis() {
            callback(bangumis: bangumis, errorType: .Success)
        }
        else {
            fetchNewBangumis(callback)
        }
    }
    
    public func fetchNewBangumis(callback: BangumisFetcherCallback) {
        NetRequester.fetchBangumis { (bangumis, errorType) -> Void in
            self.bangumis = bangumis
            callback(bangumis: bangumis, errorType: errorType)
        }
    }
    
    public func fetchCachedBangumis() -> [Bangumi]! {
        if bangumis == nil {
            retriveBangumis()
        }
        return bangumis
    }
}

// MARK: Implementation

extension BangumiManager {
    private func scheduleNotification(#bangumi: Bangumi, isSingle: Bool) {
        let bangumiNotification = UILocalNotification()
        bangumiNotification.fireDate = NSDate()
        bangumiNotification.timeZone = NSTimeZone.defaultTimeZone()
        
        var informerString: String!
        if isSingle {
            informerString = "\(bangumi.name) 第\(bangumi.epCount)集更新啦!"
        }
        else {
            informerString = "\(bangumi.name) 等更新啦!"
        }
        bangumiNotification.alertBody = informerString
        bangumiNotification.alertAction = "查看"
        bangumiNotification.applicationIconBadgeNumber += 1
        bangumiNotification.userInfo = [BangumiNotificationKey.isSingle.rawValue : isSingle,
            BangumiNotificationKey.Data.rawValue : NSKeyedArchiver.archivedDataWithRootObject(bangumi)]
        
//        UIApplication.sharedApplication().scheduleLocalNotification(bangumiNotification)
    }
    
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cacheAllData", name: UIApplicationDidEnterBackgroundNotification, object: nil);
    }
    
    @objc func cacheAllData() {
        if shouldSaveBangumiData {
            FileManager.write(starredBangumisList, filename: "BangumiList")
            cacheBangumis()
        
            shouldSaveBangumiData = false
        }
    }
    
    // MARK: Write & Read
    
    func cacheBangumis() -> Bool {
        let data = NSKeyedArchiver.archivedDataWithRootObject(bangumis)
        return FileManager.write(data, filename: "BangumisData")
    }
    
    func retriveBangumis() {
        if let data = NSData(contentsOfFile: FileManager.path(filename: "BangumisData")) {
            let bangumis = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Bangumi]
            self.bangumis = bangumis
        }
    }
    
}