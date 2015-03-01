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
    var link = ""
    var boardTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isLogin = NGTVNetworkCheck.isLogin()

        if isLogin == false {
            var alert: UIAlertView = UIAlertView(title: "로그인", message: "로그인에 실패하였습니다", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        self.boardList = BoardParser.boardList(link, page: page)
//        self.tabBarController?.tabBar.hidden = false
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.purpleColor()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func refreshData() {
        self.page = 1
        self.boardList = BoardParser.boardList(link, page: page)
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
        var addList = BoardParser.boardList(link, page: page)
        
        var indexPathArr: NSArray = NSArray()
        
        let lastBoardNo = boardList[boardList.count - 1].boardNumber!.integerValue
        
//        self.tableView.beginUpdates()
        for e in addList {
            if e.noticeYN == "Y" {
                continue
            }
            
            if e.boardNumber!.integerValue > lastBoardNo {
                continue
            }
            self.boardList.append(e)
            let indexPath = NSIndexPath(forRow: boardList.count - 1, inSection: 0)
            
            indexPathArr.arrayByAddingObject(indexPath)
        }
        
        self.tableView.reloadData()
    }
    
    
}