//
//  UIBoardDetailScrollViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 3. 23..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class UIBoardDetailScrollViewController : UIViewController, UIWebViewDelegate {
    var detail: BoardDetail = BoardDetail()
    var commentList = Array<Comment>()
    var _webView :UIWebView!
    var link:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
