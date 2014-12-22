//
//  BangumiSP.swift
//  BangumiKit
//
//  Created by kukushi on 12/22/14.
//  Copyright (c) 2014 Xing He. All rights reserved.
//

import Foundation
import SwiftyJSON

public class BangumiSP {
    let title: String!
    var description: String!
    var spID: Int!
    let coverURL: String!
    
    
    init (dict: JSON) {
        title = dict["title"].stringValue
    }
}
