//
//  NGTVHTTPUtil.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 25..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit
import SwiftHTTP

class NGTVHTTPUtil : NSObject {
    override init() {
        super.init()
    }
    
    class func login(id: NSString, passwd: NSString) {
        let url = NSURL(string: BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/user/doLogin")
        
        var post = NSString(format: "userId=\(id)&userPw=\(passwd)")
        var postData = post.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var postLength = NSString(string: "\(postData?.length)")
        
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postData
        
        var session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            BaseData.sharedInstance.refreshData()
        }).resume()
    }
    
    // 글 작성 기능(수정 포함)
    class func doWrite(boardId: NSString, title: NSString, content:NSString, imgList:NSArray, secret: NSString) {
        let request = HTTPTask()
        let url = BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/bbs/" + boardId + "/doWrite"
        var params: Dictionary<String, AnyObject> =
                [
                    "articleId": "",
                    "isNotSupport" : "0",
                    "secret" : secret,
                    "title" : title,
                    "content" : content
                ]
        var i = 1
        for img in imgList {
//            var data = UIImageJPGRepresentation(img as UIImage)
            var data = UIImageJPEGRepresentation(img as UIImage, CGFloat(0.9))
//            params.updateValue(HTTPUpload(data: data, fileName: "image\(i).png", mimeType: "image/png"), forKey: "attach\(i++)")
            params.updateValue(HTTPUpload(data: data, fileName: "image\(i).jpg", mimeType: "image/jpg"), forKey: "attach\(i++)")
            
        }

        request.POST(url,
            parameters: params,
            success : {(response: HTTPResponse) in
                println(response.text())
            }, failure: {(error: NSError, response: HTTPResponse?) in
                
            })

    }
    
    // 글 삭제 기능
    class func doDelete(boardId: NSString, boardNo: NSString) {
        let request = HTTPTask()
        let url = BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/bbs/" + boardId + "/doDelete"
        var params : Dictionary<String, AnyObject> =
        [
            "id" : boardNo
        ]
        
        request.POST(url,
            parameters: params,
            success : {(response: HTTPResponse) in
                println(response.text())
            }, failure: {(error: NSError, response: HTTPResponse?) in
                
        })
    }
    
    // 댓글 작성 기능
    class func doCommentWrite(boardId: NSString, boardNo: NSString, parentId: NSString, content: NSString) {
        let request = HTTPTask()
        let url = BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/bbs/" + boardId + "/doCommentWrite"
        var params : Dictionary<String, AnyObject> =
            [
                "idx" : boardNo,
                "parent_id" : parentId,
                "content" : content
            ]
        
        request.POST(url,
            parameters: params,
            success : {(response: HTTPResponse) in
                println(response.text())
            }, failure: {(error: NSError, response: HTTPResponse?) in
                
            })
    }
    
    // 댓글 삭제 기능
    class func doCommentDelete(boardId: NSString, boardNo: NSString, commentId: NSString) {
        let request = HTTPTask()
        let url = BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/bbs/" + boardId + "/doCommentWrite/delete"
        var params : Dictionary<String, AnyObject> =
        [
            "idx" : boardNo,
            "comment_id" : commentId
        ]
        
        request.POST(url,
            parameters: params,
            success : {(response: HTTPResponse) in
                println(response.text())
            }, failure: {(error: NSError, response: HTTPResponse?) in
                
        })
    }
    
    // 글 추천 기능
    class func doRecommend(boardId: NSString, boardNo: NSString) {
        let request = HTTPTask()
        let url = BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/bbs/" + boardId + "/doRecommend"
        var params : Dictionary<String, AnyObject> =
        [
            "id" : boardNo
        ]
        
        request.POST(url,
            parameters: params,
            success : {(response: HTTPResponse) in
                println(response.text())
            }, failure: {(error: NSError, response: HTTPResponse?) in
                
        })
    }
    
    // 댓글 추천 기능
    class func doCommentRecommend(boardId: NSString, commentId: NSString) {
        let request = HTTPTask()
        let url = BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/bbs/" + boardId + "/doCommentRecommend"
        var params : Dictionary<String, AnyObject> =
        [
            "comment_id" : commentId
        ]
        
        request.POST(url,
            parameters: params,
            success : {(response: HTTPResponse) in
                println(response.text())
            }, failure: {(error: NSError, response: HTTPResponse?) in
                
            })
    }
}
