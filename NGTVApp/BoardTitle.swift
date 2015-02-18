//
//  BoardTitle.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 18..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class BoardTitle : NSObject, Printable {
    var link : NSString?
    var title : NSString?
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "link:\(link), title:\(title)\n"
    }
}