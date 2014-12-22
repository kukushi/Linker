//
//  Bangumi.swift
//  BangumiKit
//
//  Created by kukushi on 9/7/14.
//  Copyright (c) 2014 kukushiStudio. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum BangumiSeasonType: Int {
    case Undefined = 0
    case Single
    case Multi
}

public enum WeekdayType: Int {
    case Monday = 0
    case Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    
}

public class Bangumi: NSObject, NSCoding {
    public private(set) var name: String!
    
    public var coverURLString: String!
    public var epCount: Int
    public var weekday: WeekdayType
    public var spID: Int
    public var aliasSpID: String!
    public var season: [String: Any]!
    public var seasonType: BangumiSeasonType
    public var summary: String!
    var isNew: Bool
    
    init (name: String = "") {
        epCount = 0
        weekday = .Monday
        seasonType = .Undefined
        isNew = false
        spID = 0
        self.name = name
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        self.init()
        
        name = aDecoder.decodeObjectForKey("name") as String
        epCount = aDecoder.decodeIntegerForKey("epCount")
        weekday = WeekdayType(rawValue: aDecoder.decodeIntegerForKey("weekday"))!
        spID = aDecoder.decodeIntegerForKey("spID")
        coverURLString = aDecoder.decodeObjectForKey("coverURLString") as String
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeInteger(epCount, forKey: "epCount")
        aCoder.encodeInteger(weekday.rawValue, forKey: "weekday")
        aCoder.encodeInteger(spID, forKey: "spID")
        aCoder.encodeObject(coverURLString, forKey: "coverURLString")
    }
    
    convenience init(dict: JSON) {
        self.init()
        
        name = dict["title"].stringValue
        epCount = dict["bgmcount"].intValue
        weekday = WeekdayType(rawValue: dict["weekday"].intValue)!
        spID = dict["spid"].intValue
        aliasSpID = dict["alias_spid"].stringValue
        coverURLString = dict["cover"].stringValue
    }
    
    override public var hash: Int {
        return (name + "\(epCount)").hash
    }
    
    
    override public func isEqual(object: AnyObject?) -> Bool {
        if let bangumi = object as? Bangumi {
            if bangumi.name == name && bangumi.epCount == epCount {
                return true
            }
        }
        return false
    }
    
    //
    
    func latestSeasonID() -> String {
        var seasonID = ""
        for dict in season {
            // why??? downcast to any????
            if let newdict = dict as Any as? [String: Any] {
                if let isDefault = newdict["default"] as? Bool {
                    if isDefault {
                        seasonID = newdict["season_id"] as String
                    }
                }
            }
        }
        return seasonID
    }
}
