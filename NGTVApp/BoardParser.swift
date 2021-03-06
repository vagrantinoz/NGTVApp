//
//  BoardParser.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

public class BoardParser : NSObject {    
    /*
    * 나이스게임티비의 각 게시판 주소와 페이지를 받아와서 해당 페이지의 정보를 parsing 하는 클래스 
    * url : 게시판 주소
    * page : 조회할 페이지의 게시판 페이지 번호
    * 
    * return : Board 클래스의 List
    */
    class func boardList(HTMLData : NSData) -> (Array<Board>, Bool) {
        var tmpList = Array<Board>()
        var isLast = false
        
        var doc = TFHpple(HTMLData: HTMLData)
        
        var element : NSArray = doc.searchWithXPathQuery("//table[@class='boardList']//tbody//tr")
        
        if element.count < 24 {
            isLast = true
        }
        
        for e in element {
            var tmp = Board()
            
            // 게시물 번호 혹은 공지사항 부분 "//td[1]"
            let child1 = e.searchWithXPathQuery("//td[1]")
            let noticeImg = child1[0].searchWithXPathQuery("//img")
            
            // img 태그가 없을 경우는 공지가 아닌 것으로 번호를 받아오도록 처리 
            // img 태그가 있을 경우에는 공지인 것으로 공지 이미지를 받아오도록 처리
            if noticeImg.count == 0 {
                tmp.noticeYN = "N"
            } else {
                tmp.noticeImgSrc = BaseData.sharedInstance.NICEGAMETV_ADDRESS + noticeImg[0].objectForKey("src")
                tmp.noticeYN = "Y"
            }
            
            
            // 게시물 제목 및 게시물 링크, 카운트 가져오기 "//td[2]"
            let child2 = e.searchWithXPathQuery("//td[2]")
            let titleAnker = child2[0].searchWithXPathQuery("//a")
            let countTag = child2[0].searchWithXPathQuery("//span")
            
            let title :NSString = titleAnker[0].content
            tmp.title = title.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            tmp.link = BaseData.sharedInstance.NICEGAMETV_ADDRESS + titleAnker[0].objectForKey("href")
            
            // 2015.02.28 추가(POST 처리를 위해 게시물의 실제 번호를 주소에서 가져오도록 처리
            let boardNm = titleAnker[0].objectForKey("href") as NSString
            let numberRange = boardNm.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch)
            let paramRange = boardNm.rangeOfString("?", options: NSStringCompareOptions.BackwardsSearch)
            tmp.boardNumber = boardNm.substringWithRange(NSMakeRange(numberRange.location + 1, (paramRange.location - 1) - numberRange.location))
            
            if countTag.count != 0 {
                var commCnt: NSString = countTag[0].content.description
                commCnt = commCnt.substringWithRange(NSMakeRange(0 + 1, commCnt.length - 2))
                tmp.commentCnt = commCnt as String
            }
            
            // 사용자 레벨, 레벨아이콘 이미지, nickName 가져오기 "//td[3]"
            let child3 = e.searchWithXPathQuery("//td[3]")
            let levelImgTag = child3[0].searchWithXPathQuery("//img")
            let nickTag = child3[0].searchWithXPathQuery("//span")
            
            let levelImgSrc: NSString = levelImgTag[0].objectForKey("src")
            let slashRange = levelImgSrc.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch)
            let level = levelImgSrc.substringFromIndex(slashRange.location + 1).stringByReplacingOccurrencesOfString(".gif", withString: "")
            
            tmp.level = level
            tmp.nick = nickTag[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            // 작성 시간
            let wrtTime = e.searchWithXPathQuery("//td[4]")
            tmp.wrtTime = wrtTime[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            //뷰 카운트
            let viewCnt = e.searchWithXPathQuery("//td[5]")
            tmp.viewCnt = viewCnt[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            // 추천수
            let recomCnt = e.searchWithXPathQuery("//td[6]")
            tmp.recommendCnt = recomCnt[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            tmpList.append(tmp)
        }
        return (tmpList, isLast)
    }
    
    /**
     * 상세 화면 조회 (상세글 내용, 댓글내용, 자신의 글 여부)
    **/
    class func boardDetail(HTMLData : NSData) -> (BoardDetail, Array<Comment>) {
        var detail = BoardDetail()
        
        var doc = TFHpple(HTMLData: HTMLData)
        
        self.parseBoardDetail(detail, doc: doc)
        var commentList: Array<Comment> = self.parseCommentList(doc)
        
        return (detail, commentList)
    }
    
    // TFHpple 넘겨받아 해당 부분의 게시물 상세 정보를 가져오는 함수
    private class func parseBoardDetail(detail: BoardDetail, doc: TFHpple) {
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
        detail.date = date[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let permLink = doc.searchWithXPathQuery("//p[@class='permlink']")
        detail.permLink = permLink[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let levelImgTag = doc.searchWithXPathQuery("//div[@class='subinfo']//p[@class='writer']//img")
        if levelImgTag.count > 0 {
            let levelImgSrc: NSString = levelImgTag[0].objectForKey("src")
            let slashRange = levelImgSrc.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch)
            let level = levelImgSrc.substringFromIndex(slashRange.location + 1).stringByReplacingOccurrencesOfString(".gif", withString: "")
            detail.level = level
        }
        
        let writer = doc.searchWithXPathQuery("//div[@class='subinfo']//span")
        if writer.count > 0 {
            detail.writer = writer[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        let score = doc.searchWithXPathQuery("//p[@class='score']")
        if score.count > 0 {
            detail.score = score[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        let isMineTag = doc.searchWithXPathQuery("//a[@class='del']")
        if isMineTag.count > 0 {
            detail.isMine = "Y"
        }
        
        // 기본 베이스 HTML 생성
        let content = doc.searchWithXPathQuery("//div[@class='content']")
        
        var tmpContent = content[0].raw.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        detail.content = tmpContent
    }
    
    private class func parseCommentList(doc: TFHpple) -> Array<Comment> {
        var commentList = Array<Comment>()
        // Comment 가져오기
        var xpathCommentList = doc.searchWithXPathQuery("//div[@class='comment']//div[contains(concat(' ',normalize-space(@class),' '),' item ')]")
        
        if xpathCommentList.count > 0 {
            for e in xpathCommentList {
                let tmpCmnItem = e as! TFHppleElement
                var tmp = Comment()
                
                // 댓글 data_id값을 가져온다.
                let dataIdTag = tmpCmnItem.searchWithXPathQuery("//div[@class='func']")
                
                // 삭제된 댓글일 경우 해당 태그가 없을 수 있으므로 없을경우에는 데이터를 가지고 오지 않도록 처리
                if (dataIdTag.count > 0) {
                    tmp.commentId = dataIdTag[0].objectForKey("data-id")
                    
                    // 삭제되지 않은 댓글에서만 추천 점수를 가져옴
                    let recomScore = tmpCmnItem.searchWithXPathQuery("//div[@class='recommend_score']")
                    tmp.recommentCnt = recomScore[0].content
                } else {
                    tmp.isDelete = "Y"  // 삭제된 댓글일 경우 삭제표시
                }
                
                let commentType: NSString = tmpCmnItem.objectForKey("class")
                if commentType.containsString("best") {
                    tmp.bestYN = "Y"
                } else if commentType.containsString("depth") {
                    tmp.depthYN = "Y"
                } else {
                    // 보통 댓글 처리 추가시 이용
                }
                
                let profileImgTag = tmpCmnItem.searchWithXPathQuery("//img")
                tmp.profileImg = BaseData.sharedInstance.NICEGAMETV_ADDRESS + profileImgTag[0].objectForKey("src")
                
                let levelImgTag = tmpCmnItem.searchWithXPathQuery("//p[@class='nick']//img")
                let levelImgSrc: NSString = levelImgTag[0].objectForKey("src")
                let slashRange = levelImgSrc.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch)
                let level = levelImgSrc.substringFromIndex(slashRange.location + 1).stringByReplacingOccurrencesOfString(".gif", withString: "")
                
                tmp.level = level
                
                let nick = tmpCmnItem.searchWithXPathQuery("//p[@class='nick']//span")
                tmp.nick = nick[0].content
                
                let date = tmpCmnItem.searchWithXPathQuery("//p[@class='date']")
                tmp.date = date[0].content
                
                let content = tmpCmnItem.searchWithXPathQuery("//p[@class='content']")
                tmp.content = content[0].content.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                
                // 삭제버튼 유무 체크로 자신이 쓴 댓글인지 확인
                let isMineTag = tmpCmnItem.searchWithXPathQuery("//a[@class='delete']")
                if isMineTag.count > 0 {
                    tmp.isMine = "Y"
                } else {
                    tmp.isMine = "N"
                }
                
                commentList.append(tmp)
            }
        }
        
        return commentList
    }
}