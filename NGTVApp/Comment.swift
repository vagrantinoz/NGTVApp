//
//  Comment.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class Comment: NSObject, Printable {
    var bestYN : NSString?
    var profileImg: NSString?
    var levelImg : NSString?
    var level : NSString?
    var nick : NSString?
    var recommentCnt : NSString?
    var content : NSString?
    var date : NSString?
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "bestYN:\(bestYN), profileImg:\(profileImg), levelImg:\(levelImg), level:\(level), nick:\(nick), recommentCnt:\(recommentCnt), date:\(date)\n\(content)\n"
    }
}