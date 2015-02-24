//
//  BoardParser.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import Foundation

public class BoardParser : NSObject {    
    /*
    * 나이스게임티비의 각 게시판 주소와 페이지를 받아와서 해당 페이지의 정보를 parsing 하는 클래스 
    * url : 게시판 주소
    * page : 조회할 페이지의 게시판 페이지 번호
    * 
    * return : Board 클래스의 List
    */
    class func boardList(boardUrl:NSString, page:NSInteger) -> Array<Board> {
        var tmpList = Array<Board>()
        
        let url = NSURL(string: boardUrl + "/" + page.description)
        var error = NSErrorPointer()
        var htmlString = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: error)
        var htmlData = NSData(contentsOfURL: url!)
        var doc = TFHpple(HTMLData: htmlData!)
        
        var element : NSArray = doc.searchWithXPathQuery("//table[@class='boardList']//tbody//tr")
        for e in element {
            var tmp = Board()
            
            // 게시물 번호 혹은 공지사항 부분 "//td[1]"
            let child1 = e.searchWithXPathQuery("//td[1]")
            
            let noticeImg = child1[0].searchWithXPathQuery("//img")
            
            // img 태그가 없을 경우는 공지가 아닌 것으로 번호를 받아오도록 처리 
            // img 태그가 있을 경우에는 공지인 것으로 공지 이미지를 받아오도록 처리
            if noticeImg.count == 0 {
                tmp.noticeYN = "N"
                tmp.number = child1[0].content
                
                tmp.number = tmp.number?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else {
                var src: NSString? = noticeImg[0].objectForKey("src")
                tmp.noticeImgSrc = BaseData.sharedInstance.NICEGAMETV_ADDRESS + src!
                tmp.noticeYN = "Y"
            }
            
            // 게시물 제목 및 게시물 링크, 카운트 가져오기 "//td[2]"
            let child2 = e.searchWithXPathQuery("//td[2]")
            let titleAnker = child2[0].searchWithXPathQuery("//a")
            let countTag = child2[0].searchWithXPathQuery("//span")
            
//            println(titleAnker[0].content)
//            println(titleAnker[0].objectForKey("href"))
            tmp.title = titleAnker[0].content
            tmp.link = BaseData.sharedInstance.NICEGAMETV_ADDRESS + titleAnker[0].objectForKey("href")
            
            if countTag.count != 0 {
                var commCnt: NSString = countTag[0].content.description
                commCnt = commCnt.substringWithRange(NSMakeRange(0 + 1, commCnt.length - 2))
//                println(commCnt)
                
                tmp.commentCnt = commCnt
            }
            
            // 사용자 레벨, 레벨아이콘 이미지, nickName 가져오기 "//td[3]"
            let child3 = e.searchWithXPathQuery("//td[3]")
            let levelImgTag = child3[0].searchWithXPathQuery("//img")
            let nickTag = child3[0].searchWithXPathQuery("//span")
            
//            println(levelImgTag[0].objectForKey("src"))
//            println(nickTag[0].content.description)
            
            let levelImgSrc: NSString = levelImgTag[0].objectForKey("src")
            let slashRange = levelImgSrc.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch)
            let level = levelImgSrc.substringFromIndex(slashRange.location + 1).stringByReplacingOccurrencesOfString(".gif", withString: "")
            
//            println(level)
            
            tmp.levelImg = BaseData.sharedInstance.NICEGAMETV_ADDRESS + levelImgSrc
            tmp.level = level
            tmp.nick = nickTag[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
//            println(tmp.levelImg)
//            println(tmp.level)
//            println(tmp.nick)
            
            // 작성 시간
            let wrtTime = e.searchWithXPathQuery("//td[4]")
            tmp.wrtTime = wrtTime[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            //뷰 카운트
            let viewCnt = e.searchWithXPathQuery("//td[5]")
            tmp.viewCnt = viewCnt[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            // 추천수
            let recomCnt = e.searchWithXPathQuery("//td[6]")
            tmp.recommendCnt = recomCnt[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
//            println(tmp.wrtTime)
//            println(tmp.viewCnt)
//            println(tmp.recommendCnt)
            
            tmpList.append(tmp)
        }
        
//        println(tmpList)
        
        return tmpList
    }
    
    class func boardDetail(dtlUrl: NSString) -> BoardDetail {
        let detail = BoardDetail()
        
        let url = NSURL(string: dtlUrl)
        var error = NSErrorPointer()
        var htmlString = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: error)
//        println(htmlString);
        var htmlData = NSData(contentsOfURL: url!)
        var doc = TFHpple(HTMLData: htmlData!)

        // 게시물 제목 XPath  "//div[@class='topinfo']//p[@class='title']"
        // 작성 시간 XPath   "//div[@class='topinfo']//span[@class='date']"
        // 펌링크 XPath "//p[@class=['permlink']"
        // 작성자 level Img XPath "//div[@class='subinfo']//p[@class='writer']//img
        // 작성자 nick XPath "//div[@class='subinfo']//span"
        // 작성글 내용 XPath "//div[@class='content']
        // 추천수 Xpath "//p[@class='score']
        
        let title = doc.searchWithXPathQuery("//div[@class='topinfo']//p[@class='title']")
        detail.title = title[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let date = doc.searchWithXPathQuery("//div[@class='topinfo']//span[@class='date']")
        detail.date = date[0].content
        
        let levelImgTag = doc.searchWithXPathQuery("//div[@class='subinfo']//p[@class='writer']//img")
        if levelImgTag.count > 0 {
            detail.levelImg = BaseData.sharedInstance.NICEGAMETV_ADDRESS + levelImgTag[0].objectForKey("src")
            
            let levelImgSrc: NSString = levelImgTag[0].objectForKey("src")
            let slashRange = levelImgSrc.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch)
            let level = levelImgSrc.substringFromIndex(slashRange.location + 1).stringByReplacingOccurrencesOfString(".gif", withString: "")
            detail.level = level
        }
        
        
        let nick = doc.searchWithXPathQuery("//div[@class='subinfo']//span")
        if nick.count > 0 {
            detail.nick = nick[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        let permLink = doc.searchWithXPathQuery("//p[@class='permlink']")
        detail.permLink = permLink[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        // 기본 베이스 HTML 생성
        
        let content = doc.searchWithXPathQuery("//div[@class='content']")
        
        var tmpContent = content[0].raw.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let baseHtml = "<!doctype html>" +
                        "<html>" +
                        "<head>" +
                        "<meta name=\"viewport\" content=\"width=device-width, user-scalable=no\">" +
                        "<meta http-equiv=\"Content-Type\" content=\"text/html charset=UTF-8\">" +
                        "<style>" +
                        "img {" +
                        "width:100%;" +
                        "}" +
                        "embed {" +
                        "width:100%;" +
                        "height:240px;" +
                        "}" +
                        "</style>" +
                        "</head>" +
                        "<body>" +
                        tmpContent +
                        "</body>" +
                    "</html>"
        
        detail.content = baseHtml
        
        let score = doc.searchWithXPathQuery("//p[@class='score']")
        if score.count > 0 {
            detail.recommendCnt = score[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        return detail
    }
    
    class func commentList(dtlUrl : NSString) -> Array<Comment> {
        var cmtList = Array<Comment>()
        
        let url = NSURL(string: dtlUrl)
        var error = NSErrorPointer()
        var htmlString = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: error)
        //        println(htmlString);
        var htmlData = NSData(contentsOfURL: url!)
        var doc = TFHpple(HTMLData: htmlData!)
        
        // Best Comment 가져오기
        var bestList : NSArray = doc.searchWithXPathQuery("//div[@class='comment']//div[@class='best item']")
        
        if bestList.count > 0 {
            for e in bestList {
                var tmp = Comment()
                
                tmp.bestYN = "Y"
                
                let profileImgTag = e.searchWithXPathQuery("//img")
                tmp.profileImg = BaseData.sharedInstance.NICEGAMETV_ADDRESS + profileImgTag[0].objectForKey("src")
                
                let levelImgTag = e.searchWithXPathQuery("//p[@class='nick']//img")
                let levelImgSrc: NSString = levelImgTag[0].objectForKey("src")
                let slashRange = levelImgSrc.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch)
                let level = levelImgSrc.substringFromIndex(slashRange.location + 1).stringByReplacingOccurrencesOfString(".gif", withString: "")
                
                tmp.level = level
                tmp.levelImg = levelImgSrc
                
                let nick = e.searchWithXPathQuery("//p[@class='nick']//span")
                tmp.nick = nick[0].content
                
                let date = e.searchWithXPathQuery("//p[@class='date']")
                tmp.date = date[0].content
                
                let content = e.searchWithXPathQuery("//p[@class='content']")
                tmp.content = content[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                let recomScore = e.searchWithXPathQuery("//div[@class='recommend_score']")
                tmp.recommentCnt = recomScore[0].content
                
                cmtList.append(tmp)
            }
        }
        
        // Best Comment 가져오기
        var comment : NSArray = doc.searchWithXPathQuery("//div[@class='comment']//div[@class='item']")
        
        if comment.count > 0 {
            for e in comment {
                var tmp = Comment()
                
                tmp.bestYN = "N"
                
                let profileImgTag = e.searchWithXPathQuery("//img")
                tmp.profileImg = BaseData.sharedInstance.NICEGAMETV_ADDRESS + profileImgTag[0].objectForKey("src")
                
                let levelImgTag = e.searchWithXPathQuery("//p[@class='nick']//img")
                let levelImgSrc: NSString = levelImgTag[0].objectForKey("src")
                let slashRange = levelImgSrc.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch)
                let level = levelImgSrc.substringFromIndex(slashRange.location + 1).stringByReplacingOccurrencesOfString(".gif", withString: "")
                
                tmp.level = level
                tmp.levelImg = levelImgSrc
                
                let nick = e.searchWithXPathQuery("//p[@class='nick']//span")
                tmp.nick = nick[0].content
                
                let date = e.searchWithXPathQuery("//p[@class='date']")
                tmp.date = date[0].content
                
                let content = e.searchWithXPathQuery("//p[@class='content']")
                tmp.content = content[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                let recomScore = e.searchWithXPathQuery("//div[@class='recommend_score']")
                tmp.recommentCnt = recomScore[0].content
                
                cmtList.append(tmp)
            }
            
        }
        
        return cmtList
    }
}