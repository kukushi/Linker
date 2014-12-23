//
//  Episode.swift
//  BangumiKit
//
//  Created by kukushi on 12/23/14.
//  Copyright (c) 2014 Xing He. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Episode: NSObject {
    public let videoID: Int!
    public let coverString: String!
    public let episodeIndex: String!
    public let title: String!
    
    init(dict: JSON) {
        videoID = dict["aid"].intValue
        coverString = dict["cover"].stringValue
        episodeIndex = dict["episode"].stringValue
        title = dict["title"].stringValue
    }
}
