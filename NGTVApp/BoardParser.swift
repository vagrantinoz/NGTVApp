//
//  BoardParser.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import Foundation

public class BoardParser : NSObject {
    class func getBoardList(url:NSString, page:NSString) -> Array<Board> {
        var tmpList = Array<Board>()
        
        let ngtvAddr = "http://www.nicegame.tv"
        
        let test = NSURL(string: url + "/" + page)
        var error = NSErrorPointer()
        var htmlString = NSString(contentsOfURL: test!, encoding: NSUTF8StringEncoding, error: error)
        var htmlData = NSData(contentsOfURL: test!)
//        println(htmlString)
        var doc = TFHpple(HTMLData: htmlData!)
        
        var element : NSArray = doc.searchWithXPathQuery("//table[@class='boardList']//tbody//tr")
        for e in element {
            var tmp = Board()
            
            // 게시물 번호 혹은 공지사항 부분 "//td[1]"
            var child1 = e.searchWithXPathQuery("//td[1]")
            
            let imgTag = child1[0].searchWithXPathQuery("//img")
            
            // img 태그가 없을 경우는 공지가 아닌 것으로 번호를 받아오도록 처리 
            // img 태그가 있을 경우에는 공지인 것으로 공지 이미지를 받아오도록 처리
            if imgTag.count == 0 {
                tmp.noticeYN = "N"
                tmp.number = child1[0].content
                
                tmp.number = tmp.number?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            } else {
                var src: NSString? = imgTag[0].objectForKey("src")
                tmp.noticeImgSrc = ngtvAddr + src!
                tmp.noticeYN = "Y"
            }
            
            // 게시물 제목 및 게시물 링크, 카운트 가져오기 "//td[2]"
            
        }
        
        return tmpList
    }
}