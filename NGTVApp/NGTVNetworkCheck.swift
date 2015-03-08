//
//  NGTVNetworkChk.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 25..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class NGTVNetworkCheck : NSObject {
    override init() {
        super.init()
    }
    
    class func isLogin() -> Bool {
        BaseData.sharedInstance.refreshData()
        var htmlString = NSString(bytes: BaseData.sharedInstance.baseData.bytes, length: BaseData.sharedInstance.baseData.length, encoding: NSUTF8StringEncoding)
        
        if(htmlString!.containsString("value=\"로그인\"")) {
           return false
        } else {
           return true
        }
    }
}
