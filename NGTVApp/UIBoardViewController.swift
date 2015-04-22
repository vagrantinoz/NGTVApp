//
//  UIBoardViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 18..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class UIBoardViewController : UITableViewController, UINavigationControllerDelegate {
    var boardList = Array<Board>()
    var page : Int = 1
    var board : BoardTitle!
    var isLast = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = board.title as String
        
        // RefreshControl 등록
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(146.0/255.0), blue: CGFloat(189.0/255.0), alpha: CGFloat(1.0))
        self.refreshControl!.tintColor = UIColor.whiteColor()
        self.refreshControl!.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        
        let isLogin = NGTVNetworkCheck.isLogin()
        
        if isLogin {    // Login 상태일때
            // barItem 등록
            let btnSearch: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("search"))
            let btnAdd: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("write"))
            let btns :NSArray = NSArray(objects: btnAdd, btnSearch)
            self.navigationItem.rightBarButtonItems = btns as [AnyObject]
        } else {  // Login 상태가 아닐때
            let btnSearch: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("search"))
            let btns :NSArray = NSArray(objects: btnSearch)
            self.navigationItem.rightBarButtonItems = btns as [AnyObject]
        }
        
        self.addBoardList()
    }
    
    func search() {
        println("search")
    }
    
    func write() {
        let writeCtrl:BoardWriteViewController = self.storyboard?.instantiateViewControllerWithIdentifier("boardWrite")! as! BoardWriteViewController
        
        writeCtrl.boardId = board.boardId as String
        
        presentViewController(writeCtrl, animated: true, completion: nil)
    }
    
    func refreshData() {
        self.boardList.removeAll(keepCapacity: false)
        self.page = 1
        
        self.addBoardList()

        self.reloadData()
    }
    
    func reloadData() {
        if (self.refreshControl != nil) {
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.boardList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.boardList.count > 0 {
            let cellIdentifier: String = "boardViewCell"
            var cell: UIBoardViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UIBoardViewCell
            
            let row = indexPath.row
            
            cell.title.text = self.boardList[row].title
            cell.nick.text = self.boardList[row].nick
            
            var img = UIImage(named: boardList[row].level)
            cell.levelImg.image = img
            
            cell.wrtTime.text = "\(self.boardList[row].wrtTime) (\(self.boardList[row].viewCnt))"
            
            // 댓글 모양새 변경
            cell.comment.font = UIFont(name: "GillSans-Bold", size: 13)
            cell.comment.layer.masksToBounds = true
            cell.comment.layer.cornerRadius = 5
            
            var commentCnt = 0
            
            let commentCntString = self.boardList[row].commentCnt as NSString
            
            if commentCntString != "" {
                commentCnt = commentCntString.integerValue
            }

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
            
            if isLast == false {
                if indexPath.row == boardList.count - 1 {
                    self.addBoardList()
                }
            }
            return cell
        } else {
            return UIBoardViewCell()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BoardDetail" {
//            var detailCtrl: UIBoardDetailViewController = segue.destinationViewController as UIBoardDetailViewController
            
            var detailCtrl : UIBoardDetailTableViewController = segue.destinationViewController as! UIBoardDetailTableViewController
            
            let myIndexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            tableView.deselectRowAtIndexPath(myIndexPath, animated: false)
            
            let row = myIndexPath.row
            
            detailCtrl.link = boardList[row].link
        }
    }
    
    func addBoardList() {
        let manager = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        manager.responseSerializer = AFHTTPResponseSerializer()
        let request : NSMutableURLRequest = AFHTTPRequestSerializer().requestWithMethod("GET", URLString: (board.link as String) + "/\(self.page)", parameters: nil, error: nil)
        
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
                    var tmpList = Array<Board>()
                    
                    (tmpList, self.isLast) = BoardParser.boardList(responseObject as! NSData)
                    
                    var lastBoardNo = 0
                    if self.boardList.count > 0 {
                        lastBoardNo = self.boardList[self.boardList.count - 1].boardNumber.integerValue
                    }
                    
                    for item in tmpList {
                        if self.page > 1 {
                            if item.noticeYN == "Y" {
                                continue
                            }
                            
                            if item.boardNumber.integerValue >= lastBoardNo {
                                continue
                            }
                            
                            self.boardList.append(item)
                            
                        } else {
                            self.boardList.append(item)
                        }
                        
                    }
                    
                    self.page += 1
                    
                    self.tableView.reloadData()
                }
            }
        })
        
        task.resume()
    }
    
}