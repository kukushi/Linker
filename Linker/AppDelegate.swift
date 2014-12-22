//
//  AppDelegate.swift
//  Linker
//
//  Created by kukushi on 12/18/14.
//  Copyright (c) 2014 Xing He. All rights reserved.
//

import UIKit
import BangumiKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // TODO: Remove it to needed time
        if NSProcessInfo().operatingSystemVersion.majorVersion >= 8 {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
        }
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        BangumiManager.sharedManager.checkBangumisUpdate(bangumiBackrgoundFetcher: completionHandler)
    }
    
}

