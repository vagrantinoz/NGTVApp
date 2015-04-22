//
//  NGTVHTTPAFNetworking.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 3. 15..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class NGTVHTTPAFNetworking : NSObject {
    let url = NSURL(string: BaseData.sharedInstance.NICEGAMETV_ADDRESS)
    let manager : AFHTTPRequestOperationManager!
    let sessionManager : AFURLSessionManager!
    
    var responseObject: NSObject!
    
    override init() {
        manager = AFHTTPRequestOperationManager(baseURL: url)
        sessionManager = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        sessionManager.responseSerializer = AFHTTPResponseSerializer()
    }
    
    func login(id: NSString, passwd: NSString) {
        /*
        manager.responseSerializer = AFHTTPResponseSerializer()
        var parameters = ["userId": id, "userPw" : passwd];
        
        let op = manager.POST(BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/user/doLogin", parameters: parameters,
        success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            println(operation.responseString)
            BaseData.sharedInstance.refreshData()
        }) { (operation: AFHTTPRequestOperation!, error:NSError!) -> Void in
            println(error.localizedDescription)
        }
        
        op.start()
        */
    /*
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
        } error:nil];
    */
        
        var parameters = ["userId": id, "userPw" : passwd];
        var request : NSMutableURLRequest = AFHTTPRequestSerializer().requestWithMethod("POST", URLString: BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/user/doLogin", parameters: parameters, error: nil)
        
        let dataTask : NSURLSessionDataTask = sessionManager.dataTaskWithRequest(request, completionHandler: { (response : NSURLResponse!, responseObject: AnyObject!, error: NSError!) -> Void in
            if((error) != nil) {
                println("ERROR:\(error.localizedDescription)")
            } else {
//                println(NSString(data: responseObject as NSData, encoding: NSUTF8StringEncoding))
                BaseData.sharedInstance.refreshData()
            }
        })
        
        dataTask.resume()
    }
    
    func doWrite(boardId: NSString, title: NSString, content:NSString, imgList:NSArray, secret: NSString) {
        let url = BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/bbs/" + (boardId as String) + "/doWrite"
        var params: Dictionary<String, AnyObject> =
        [
            "articleId": "",
            "isNotSupport" : "0",
            "secret" : secret,
            "title" : title,
            "content" : content
        ]
        
        /*
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
        } error:nil];
        */
        
        let request: NSMutableURLRequest = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: url, parameters: params, constructingBodyWithBlock: { (formData : AFMultipartFormData!) -> Void in
            for img in imgList {
                let tmpImg = img as! UIImage
            }
        }, error: nil)
    }
}
