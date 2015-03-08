//
//  UIBoardViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 18..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class UIBoardViewController : UITableViewController {
    var boardList = Array<Board>()
    var page : Int = 1
    var board : BoardTitle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isLogin = NGTVNetworkCheck.isLogin()
        
        self.boardList = BoardParser.boardList(board.link!, page: page)
        
        // RefreshControl 등록
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.backgroundColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(146.0/255.0), blue: CGFloat(189.0/255.0), alpha: CGFloat(1.0))
        self.refreshControl!.tintColor = UIColor.whiteColor()
        self.refreshControl!.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        
        // barItem 등록
        let btnSearch: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("search"))
        let btnAdd: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("write"))
        let btns :NSArray = NSArray(objects: btnAdd, btnSearch)
        self.navigationItem.rightBarButtonItems = btns
    }
    
    func search() {
        println("search")
    }
    
    func write() {
        println("write")
    }
    
    func refreshData() {
        self.page = 1
        self.boardList = BoardParser.boardList(board.link!, page: page)
        self.reloadData()
    }
    
    func reloadData() {
        self.tableView.reloadData()
        
        if (self.refreshControl? != nil) {
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
        let cellIdentifier: NSString = "boardViewCell"
        var cell: UIBoardViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UIBoardViewCell
        
        let row = indexPath.row
        
        cell.title.text = self.boardList[row].title
        cell.nick.text = self.boardList[row].nick
        
        var img = UIImage(named: boardList[row].level!)
        cell.levelImg.image = img
        
        cell.wrtTime.text = "\(self.boardList[row].wrtTime!) (\(self.boardList[row].viewCnt!))"
        
        // 댓글 모양새 변경
        cell.comment.font = UIFont(name: "GillSans-Bold", size: 13)
        cell.comment.layer.masksToBounds = true
        cell.comment.layer.cornerRadius = 5
        
        var commentCnt = 0
        
        if self.boardList[row].commentCnt != nil {
            commentCnt = self.boardList[row].commentCnt!.integerValue
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
        
        if indexPath.row == boardList.count - 1 {
            self.addBoardList(++page)
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BoardDetail" {
//            var detailCtrl: UIBoardDetailViewController = segue.destinationViewController as UIBoardDetailViewController
            
            var detailCtrl : UIBoardDetailTableViewController = segue.destinationViewController as UIBoardDetailTableViewController
            
            let myIndexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            tableView.deselectRowAtIndexPath(myIndexPath, animated: false)
            
            let row = myIndexPath.row
            
            detailCtrl.board = boardList[row]
        }
    }
    
    func addBoardList(page: Int) {
        var addList = BoardParser.boardList(board.link!, page: page)
        
        var indexPathArr: NSArray = NSArray()
        
        let lastBoardNo = boardList[boardList.count - 1].boardNumber!.integerValue
        
//        self.tableView.beginUpdates()
        for e in addList {
            if e.noticeYN == "Y" {
                continue
            }
            
            if e.boardNumber!.integerValue >= lastBoardNo {
                continue
            }
            self.boardList.append(e)
            let indexPath = NSIndexPath(forRow: boardList.count - 1, inSection: 0)
            
            indexPathArr.arrayByAddingObject(indexPath)
        }
        
        self.tableView.reloadData()
    }
    
    
}