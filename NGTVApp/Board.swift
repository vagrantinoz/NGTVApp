//
//  Board.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class Board : NSObject, Printable {
    var noticeYN : NSString?
    var noticeImgSrc : NSString?
    var boardNumber : NSString?
    var link : NSString?
    var level : NSString?
    var nick : NSString?
    var title : NSString?
    var commentCnt : NSString?
    var wrtTime : NSString?
    var viewCnt : NSString?
    var recommendCnt : NSString?
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "noticeYN:\(noticeYN), noticeImgSrc:\(noticeImgSrc), number:\(boardNumber), link:\(link), " +
            "level:\(level), nick:\(nick), title:\(title), commentCnt:\(commentCnt), wrtTime:\(wrtTime), viewCnt:\(viewCnt), recommendCnt:\(recommendCnt)\n"
    }
}