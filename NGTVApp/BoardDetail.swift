//
//  BoardDetail.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class BoardDetail : NSObject, Printable {
    var title : String = ""
    var date : String = ""
    var writer : String = ""
    var level : String = ""
    var score : String = ""
    var permLink : String = ""
    var content : String = ""
    var isMine : String = "N"
    
    override init() {
        super.init()
    }
    
    override var description: String {
        return "permLink:\(permLink), isMine:\(isMine)\n\(content)"
    }
}