//
//  Comment.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class Comment: NSObject, Printable {
    var commentId: String = ""
    var bestYN : String = "N"
    var depthYN : String = "N"
    var profileImg: String = ""
    var level : String = ""
    var nick : String = ""
    var recommentCnt : String = ""
    var content : String = ""
    var date : String = ""
    var isMine : String = ""
    var isDelete : String = "N"
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "commentId:\(commentId), bestYN:\(bestYN), depth:\(depthYN), profileImg:\(profileImg), level:\(level), nick:\(nick), recommentCnt:\(recommentCnt), date:\(date), isMine: \(isMine)\n\(content)\n"
    }
}