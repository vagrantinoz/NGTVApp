//
//  BaseData.swift
//  NGTVApp
//  기본적인 정보에 대해 매번 페이지를 호출하는 문제점을 고치기 위해서 
//  최초 앱 실행시에 커뮤니티 부분 HTML 데이터를 가져와 저장하고 있는 객체 생성
//  커뮤니티 기본 URL : http://www.nicegame.tv/bbs/freeboard/list
//
//  Created by lunafei on 2015. 2. 24..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class BaseData:NSObject {
    /*
    class let instance : BaseData {
        return
    }
    */
    class var sharedInstance:BaseData {
        struct Static {
            static let instance: BaseData = BaseData()
        }
        return Static.instance
    }
    
    var baseData: NSData!
    let NICEGAMETV_ADDRESS = "http://www.nicegame.tv"
    
    override init() {
        let url = NSURL(string: "http://www.nicegame.tv/bbs/freeboard/list")
        var error = NSErrorPointer()
        var htmlString = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: error)
        self.baseData = NSData(contentsOfURL: url!)
        
        super.init()
    }
    
    func refreshData() {
        let url = NSURL(string: "http://www.nicegame.tv/bbs/freeboard/list")
        var error = NSErrorPointer()
        var htmlString = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: error)
        self.baseData = NSData(contentsOfURL: url!)
    }
    
    func baseHTML(content: String) -> String {
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
            content +
            "</body>" +
        "</html>"
        
        return baseHtml
    }
}
