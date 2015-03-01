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
        
        var doc = TFHpple(HTMLData: BaseData.sharedInstance.baseData)
        
        var element : NSArray = doc.searchWithXPathQuery("//div[@class='sideMenu']//dl[2]//dd//a")
        
        for i in 0...element.count - 1 {
            var tmp = BoardTitle()
            var boardId = element[i].objectForKey("href") as NSString
            
            boardId = boardId.stringByReplacingOccurrencesOfString("/bbs/", withString: "")
            boardId = boardId.stringByReplacingOccurrencesOfString("/list", withString: "")
            
            tmp.boardId = boardId
            tmp.link = BaseData.sharedInstance.NICEGAMETV_ADDRESS + element[i].objectForKey("href")
            tmp.title = element[i].content
            
            titleList.append(tmp)
        }
        
        return titleList
    }
}