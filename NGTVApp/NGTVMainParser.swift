//
//  NGTVMainParser.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 18..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import Foundation

public class NGTVMainParser : NSObject {
    class func communityBoardList(HTMLData : NSData) -> (/*noticeList: Array<BoardTitle>, */commuList: Array<BoardTitle>, etcList: Array<BoardTitle>) {
        var commuList = Array<BoardTitle>()
        var etcList = Array<BoardTitle>()
        
        var doc = TFHpple(HTMLData: HTMLData)
        
        var element = doc.searchWithXPathQuery("//div[@class='sideMenu']//dl[2]//dd//a")
        
        for i in 0...element.count - 1 {
            var tmp = BoardTitle()
            var boardId = element[i].objectForKey("href") as NSString
            
            boardId = boardId.stringByReplacingOccurrencesOfString("/bbs/", withString: "")
            boardId = boardId.stringByReplacingOccurrencesOfString("/list", withString: "")
            
            tmp.boardId = boardId as String
            tmp.link = BaseData.sharedInstance.NICEGAMETV_ADDRESS + element[i].objectForKey("href")
            tmp.title = element[i].content
            
            commuList.append(tmp)
        }
        
        element = doc.searchWithXPathQuery("//div[@class='sideMenu']//dl[3]//dd//a")
        
        for i in 0...element.count - 1 {
            var boardId = element[i].objectForKey("href") as NSString
            
            boardId = boardId.stringByReplacingOccurrencesOfString("/bbs/", withString: "")
            boardId = boardId.stringByReplacingOccurrencesOfString("/list", withString: "")
            
            if boardId == "rank" {
                continue;
            }
            
            var tmp = BoardTitle()
            
            tmp.boardId = boardId
            tmp.link = BaseData.sharedInstance.NICEGAMETV_ADDRESS + element[i].objectForKey("href")
            tmp.title = element[i].content
            
            etcList.append(tmp)
        }
        
        return (commuList, etcList)
    }
}