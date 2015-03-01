//
//  BoardDetail.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class BoardDetail : NSObject, Printable {
    var permLink : NSString?
    var content : NSString?
    var isMine : NSString = "N"
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "permLink:\(permLink), isMine:\(isMine)\n\(content)"
    }
}