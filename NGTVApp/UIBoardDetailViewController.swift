//
//  UIBoardDetailViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 18..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

// 상세보기 화면 구현 기본
// 1. 기본 베이스 ViewController를 TableViewController로 설정
// 2. prototypeCell 디자인을 3개 구현함
// 3. 기본 베이스가 될 TableView의 Row수를 3개로 고정
// 4. 1번째 로우에는 작성글 기본정보, 2번째 글에는 WebView를 이용한 게시글 상세내용 표시
// 5. 3번째 로우에 UITableView를 삽입한 뒤에 protoTypeCell 하나 설정
// 6. 해당 부분에는 댓글 데이터 넣기

import UIKit

class UIBoardDetailViewController : UIViewController, UIWebViewDelegate {
    var boardDetail = BoardDetail()
    var commentList = Array<Comment>()
    var link = ""
    var board: Board = Board()
    
    @IBOutlet var content: UIWebView!
    
    var url = NSURL(string: "http://www.nicegame.tv")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content.delegate = self;
        
        boardDetail = BoardParser.boardDetail(board.link!)
        commentList = BoardParser.commentList(board.link!)
        
        content.loadHTMLString(boardDetail.content, baseURL: url)
        
        println(boardDetail)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        println("asdf")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        /*
        var frame = webView.frame
        frame.size.width = 600
        frame.size.height = 1
        webView.frame = frame
        
        var fittingSize = webView.sizeThatFits(CGSizeZero)
        frame.size = fittingSize
        
        webView.frame = frame

        println("size : \(fittingSize.width), \(fittingSize.height)")
        */
        /*
        CGRect newBounds = webView.bounds;
        newBounds.size.height = webView.scrollView.contentSize.height;
        webView.bounds = newBounds;
        */
        
        /*
        // 불러온 웹뷰 페이지의 ScrollView 사이즈만큼 webView의 사이즈를 늘려줌
        var newBounds = webView.bounds
        newBounds.size.height = webView.scrollView.contentSize.height
        webView.bounds = newBounds
        */
        
    }
}