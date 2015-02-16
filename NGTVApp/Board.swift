//
//  Board.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import Foundation

class Board : NSObject {
    var noticeYN : NSString?
    var noticeImgSrc : NSString?
    var number : NSString?
    var link : NSString?
    var levelImg : NSString?
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
}