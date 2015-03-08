//
//  Comment.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class Comment: NSObject, Printable {
    var commentId: NSString?
    var bestYN : NSString = "N"
    var depthYN : NSString = "N"
    var profileImg: NSString?
    var level : NSString?
    var nick : NSString?
    var recommentCnt : NSString?
    var content : NSString?
    var date : NSString?
    var isMine : NSString?
    var isDelete : NSString = "N"
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "commentId:\(commentId), bestYN:\(bestYN), depth:\(depthYN), profileImg:\(profileImg), level:\(level), nick:\(nick), recommentCnt:\(recommentCnt), date:\(date), isMine: \(isMine)\n\(content)\n"
    }
}