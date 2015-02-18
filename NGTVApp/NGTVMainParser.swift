//
//  NGTVMainParser.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 18..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import Foundation

public class NGTVMainParser : NSObject {
    class func communityBoardList() -> Array<BoardTitle> {
        var titleList = Array<BoardTitle>()
        
        let NICEGAMETV_ADDRESS = "http://www.nicegame.tv"
        
        let url = NSURL(string: "http://www.nicegame.tv/bbs/freeboard/list")
        var error = NSErrorPointer()
        var htmlString = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: error)
        var htmlData = NSData(contentsOfURL: url!)
        var doc = TFHpple(HTMLData: htmlData!)
        
        var element : NSArray = doc.searchWithXPathQuery("//div[@class='sideMenu']//dl[2]//dd//a")
        
        for i in 0...element.count - 1 {
            var tmp = BoardTitle()
            
            tmp.link = NICEGAMETV_ADDRESS + element[i].objectForKey("href")
            tmp.title = element[i].content
            
            titleList.append(tmp)
        }
        
        return titleList
    }
}