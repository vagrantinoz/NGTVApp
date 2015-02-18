//
//  BoardDetail.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class BoardDetail : NSObject, Printable {
    var title : NSString?
    var date : NSString?
    var level : NSString?
    var levelImg : NSString?
    var nick : NSString?
    var permLink : NSString?
    var content : NSString?
    var recommendCnt : NSString?
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "title:\(title), date:\(date), level:\(level), levelImg:\(levelImg), nick:\(nick), permLink:\(permLink), recommendCnt:\(recommendCnt)\n\(content)"
    }
}