//
//  UIBoardDetailTableViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 20..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

// TODO : 댓글 작성 후 리플래쉬 할 때에 상단 제목 부분 정보 재로딩 처리 필요

import UIKit

class UIBoardDetailTableViewController :UITableViewController, UIWebViewDelegate{
    var detail: BoardDetail = BoardDetail()
    var commentList = Array<Comment>()
//    var board: Board = Board()
    var _url = NSURL(string: "http://www.nicegame.tv")
    var _webView : UIWebView!
    var link:String!
    
    var commentCell: UICommentViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        (detail, commentList) = BoardParser.boardDetail(board.link!)
//        self.tabBarController?.tabBar.hidden = true
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.sectionHeaderHeight = 0;
        self.tableView.sectionFooterHeight = 0;
        
        commentCell = UICommentViewCell()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(146.0/255.0), blue: CGFloat(189.0/255.0), alpha: CGFloat(1.0))
        self.refreshControl!.tintColor = UIColor.whiteColor()
        self.refreshControl!.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.getBoardDetail()
        
//        self.tableView.hidden = true
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        } else {
            return 30
        }
    }
    
    func refreshData() {
//        (detail, commentList) = BoardParser.boardDetail(board.link!)
        self.getBoardDetail()
        self.reloadData()
    }
    
    func reloadData() {
        if (self.refreshControl != nil) {
            self.refreshControl?.endRefreshing()
        }
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
                var cell : UIBoardViewCell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as! UIBoardViewCell
                
                cell.title.text = self.detail.title as String
                cell.nick.text = self.detail.writer as String
                
                var img = UIImage(named: self.detail.level as String)
                cell.levelImg.image = img
                
                cell.wrtTime.text = "\(self.detail.date)"
                
                // 댓글 모양새 변경
                cell.comment.font = UIFont(name: "GillSans-Bold", size: 13)
                cell.comment.layer.masksToBounds = true
                cell.comment.layer.cornerRadius = 5
                
                var commentCnt = self.commentList.count
                
                cell.comment.text = "\(commentCnt)"
                
                // 각 댓글 갯수별로 댓글 배경색 변경
                if commentCnt > 40 {
                    cell.comment.backgroundColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(105.0/255.0), blue: CGFloat(166.0/255.0), alpha: CGFloat(1.0))
                } else if commentCnt > 20 {
                    cell.comment.backgroundColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(158.0/255.0), blue: CGFloat(11.0/255.0), alpha: CGFloat(1.0))
                } else if commentCnt > 0 {
                    cell.comment.backgroundColor = UIColor(red: CGFloat(139.0/255.0), green: CGFloat(226.0/255.0), blue: CGFloat(253.0/255.0), alpha: CGFloat(1.0))
                } else {
                    cell.comment.backgroundColor = UIColor(red: CGFloat(169.0/255.0), green: CGFloat(170.0/255.0), blue: CGFloat(168.0/255.0), alpha: CGFloat(1.0))
                }
                
                // 사용자가 셀을 클릭해도 선택이 안된거처럼 보이도록 설정
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                return cell
            }
            else/* if indexPath == 1*/ {  // 게시물 내용 부분
                let cellIndentifier = "boardDetailViewCell"
                var cell : UIBoardDetailViewCell
                = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as! UIBoardDetailViewCell
                
                if detail.content != "" {
                    _webView = cell.content
                    
                    _webView.delegate = self
                    _webView.loadHTMLString(BaseData.sharedInstance.baseHTML(detail.content) as String, baseURL: _url)
                    _webView.layer.cornerRadius = 0
                    _webView.userInteractionEnabled = true
                    _webView.clipsToBounds = true
                    _webView.scalesPageToFit = false
                    _webView.scrollView.scrollEnabled = false
                    _webView.scrollView.bounces = true
                }
                
//                _webView.scrollView.addObserver(self, forKeyPath: "webViewScroll", options: NSKeyValueObservingOptions.New, context: nil)
                
                // 사용자가 셀을 클릭해도 선택이 안된거처럼 보이도록 설정
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                return cell
            }
        } else {
            let cellIndentifier = "commentViewCell"
            var cell : UICommentViewCell
            = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as! UICommentViewCell
            cell.content.text = commentList[indexPath.row].content
//            cell.content.addObserver(self, forKeyPath: "commentSize", options: NSKeyValueObservingOptions.New, context: nil)
            //cell.comment.text = commentList[indexPath.row].content
            cell.nick.text = commentList[indexPath.row].nick
            
            var img = UIImage(named: commentList[indexPath.row].level)
            cell.levelImg.image = img
            
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
        frame.size.height = fittingSize.height + 20.0
        webView.frame = frame
        
//        self.tableView.hidden = false

        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                if _webView == nil {
                    return 0
                } else {
                    return _webView!.frame.size.height
                }
                
            }
        }
        
        return UITableViewAutomaticDimension
    }

    /*
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    */
    func getBoardDetail() {
        let manager = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        manager.responseSerializer = AFHTTPResponseSerializer()
        let request : NSMutableURLRequest = AFHTTPRequestSerializer().requestWithMethod("GET", URLString: self.link!, parameters: nil, error: nil)
        
        let task = manager.dataTaskWithRequest(request, completionHandler: { (response:NSURLResponse!, responseObject:AnyObject!, error:NSError!) -> Void in
            if((error) != nil) {
                let alert = UIAlertView(title: "실패", message: "데이터를 불러오지 못했습니다", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            } else {
                let responseCode = (response as? NSHTTPURLResponse)?.statusCode ?? -1
                
                // responseCode 200이 아닐경우(200이 아니면 정상적인 페이지 로딩이 아니다)
                if (responseCode != 200) {
                    let alert = UIAlertView(title: "502오류", message: "502 GateError가 발생하였습니다. 앱 종료 후 다시 시도해 주십시오", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                } else {
                    var doc = TFHpple(HTMLData: responseObject as! NSData)
                    
                    (self.detail, self.commentList) = BoardParser.boardDetail(responseObject as! NSData)
                    
                    self.tableView.reloadData()
                }
            }
        })
        
        task.resume()
    }
}
