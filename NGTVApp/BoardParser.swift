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
        
        let test = NSURL(string: url + "/" + page)
        var error = NSErrorPointer()
        var htmlString = NSString(contentsOfURL: test!, encoding: NSUTF8StringEncoding, error: error)
        var htmlData = NSData(contentsOfURL: test!)
        println(htmlString)
        var doc = TFHpple(HTMLData: htmlData!)
        
        var element : NSArray = doc.searchWithXPathQuery("//table[class=boardList]/tbody/tr")
        for e in element {
            var tmp : Board
            println(htmlString)
        }
        return tmpList
    }
}