//
//  Episode.swift
//  BangumiKit
//
//  Created by kukushi on 12/23/14.
//  Copyright (c) 2014 Xing He. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Episode: NSObject, NSCoding {
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
    
    public required init(coder aDecoder: NSCoder) {
        videoID = aDecoder.decodeIntegerForKey("VideoID")
        coverString = aDecoder.decodeObjectForKey("coverString") as String
        episodeIndex = aDecoder.decodeObjectForKey("episodeIndex") as String
        title = aDecoder.decodeObjectForKey("title") as String
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(videoID, forKey: "VideoID")
        aCoder.encodeObject(coverString, forKey: "coverString")
        aCoder.encodeObject(episodeIndex, forKey: "episodeIndex")
        aCoder.encodeObject(title, forKey: "titile")
    }
}
