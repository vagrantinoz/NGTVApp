//
//  UIBoardDetailTableViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 20..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class UIBoardDetailTableViewController :UITableViewController, UIWebViewDelegate {
    var detail: BoardDetail = BoardDetail()
    var commentList = Array<Comment>()
    var board: Board = Board()
    var _url = NSURL(string: "http://www.nicegame.tv")
    var _webView : UIWebView!
    
    var commentCell: UICommentViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detail = BoardParser.boardDetail(board.link!)
        commentList = BoardParser.commentList(board.link!)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if commentList.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return commentList.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var index = indexPath.row
            if index == 0 {         // 게시물 제목 부분
                let cellIndentifier = "boardViewCell"
                var cell : UIBoardViewCell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as UIBoardViewCell
                
                cell.title.text = board.title
                cell.nick.text = board.nick
                
                var img = UIImage(named: board.level!)
                cell.levelImg.image = img
                
                // 사용자가 셀을 클릭해도 선택이 안된거처럼 보이도록 설정
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                return cell
            }
            else/* if indexPath == 1*/ {  // 게시물 내용 부분
                let cellIndentifier = "boardDetailViewCell"
                var cell : UIBoardDetailViewCell
                = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as UIBoardDetailViewCell
                
                _webView = cell.content
                
                _webView.delegate = self
                _webView.loadHTMLString(detail.content, baseURL: _url)
                _webView.layer.cornerRadius = 0
                _webView.userInteractionEnabled = true
                _webView.clipsToBounds = true
                _webView.scalesPageToFit = false
                _webView.scrollView.scrollEnabled = false
                _webView.scrollView.bounces = true
                
                _webView.hidden = true
                
                // 사용자가 셀을 클릭해도 선택이 안된거처럼 보이도록 설정
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                return cell
            }
        } else {
            let cellIndentifier = "commentViewCell"
            var cell : UICommentViewCell
            = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as UICommentViewCell
            
            cell.comment.text = commentList[indexPath.row].content
            cell.nick.text = commentList[indexPath.row].nick
            
            var img = UIImage(named: commentList[indexPath.row].level!)
            cell.levelImg.image = img
            
            cell.comment.sizeToFit()
            
            return cell
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
//        println("finish")
        // 불러온 웹뷰 페이지의 ScrollView 사이즈만큼 webView의 사이즈를 늘려줌
//        var newBounds = webView.bounds
//        newBounds.size.height = webView.scrollView.contentSize.height
//        webView.bounds = newBounds

        var frame :CGRect = webView.frame
        frame.size.height = 1
        webView.frame = frame
        
        var fittingSize = webView.sizeThatFits(CGSizeZero)
        frame.size.height = fittingSize.height + 20
        webView.frame = frame
        
        _webView.hidden = false
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
//        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 84
            } else if indexPath.row == 1 {
                if _webView == nil {
                    return 0
                } else {
                    return _webView!.frame.height
                }
                
            }
        } else if indexPath.section == 1 {
//            commentCell = tableView.dequeueReusableCellWithIdentifier("commentViewCell", forIndexPath: indexPath) as UICommentViewCell
            return 60
        }
        
        return 400
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

    }
}
