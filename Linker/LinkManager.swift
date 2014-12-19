//
//  LinkManager.swift
//  Linker
//
//  Created by kukushi on 12/19/14.
//  Copyright (c) 2014 Xing He. All rights reserved.
//

class LinkManager {
    class var sharedManager: LinkManager {
        struct Static {
            static let sharedManager = LinkManager()
        }
        return Static.sharedManager
    }
}
