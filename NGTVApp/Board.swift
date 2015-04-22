//
//  Board.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class Board : NSObject, Printable {
    var noticeYN : String = ""
    var noticeImgSrc : String = ""
    var boardNumber : NSString = ""
    var link : String = ""
    var level : String = ""
    var nick : String = ""
    var title : String = ""
    var commentCnt : String = ""
    var wrtTime : String = ""
    var viewCnt : String = ""
    var recommendCnt : String = ""
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "noticeYN:\(noticeYN), noticeImgSrc:\(noticeImgSrc), number:\(boardNumber), link:\(link), " +
            "level:\(level), nick:\(nick), title:\(title), commentCnt:\(commentCnt), wrtTime:\(wrtTime), viewCnt:\(viewCnt), recommendCnt:\(recommendCnt)\n"
    }
}