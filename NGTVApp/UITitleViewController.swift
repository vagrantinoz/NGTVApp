//
//  UITitleViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 18..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class UITitleViewController : UITableViewController {
    var commuList = Array<BoardTitle>()
    var etcList = Array<BoardTitle>()
    let device = UIDevice.currentDevice()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        device.scheduleReachabilityWatcher(self)
        
        if device.networkAvailable() {
            println("device.networkAvailable()")
        }
        
        if device.activeWLAN() {
            println("device.activeWLAN()")
        } else if device.activeWWAN() {
            println("device.activeWWAN()")
        }
        
        (commuList, etcList) = NGTVMainParser.communityBoardList()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(146.0/255.0), blue: CGFloat(189.0/255.0), alpha: CGFloat(1.0))
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(objectsAndKeys: UIColor.whiteColor(), NSForegroundColorAttributeName,
         UIFont(name: "AppleSDGothicNeo-Bold", size: 18.0)!, NSFontAttributeName)
        
        if NGTVNetworkCheck.isLogin() == false {
            let btnAdd: UIBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("login"))
            self.navigationItem.rightBarButtonItem = btnAdd
        } else {
            let btnAdd: UIBarButtonItem = UIBarButtonItem(title: "LogOut", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("logOut"))
            self.navigationItem.rightBarButtonItem = btnAdd
        }
    }
    
    func login() {
        println("login")
    }
    
    func logOut() {
        println("logOut")
    }
    
    func reachabilityChanged() {
        if device.networkAvailable() {
            println("device.networkAvailable()")
        }
        
        if device.activeWLAN() {
            println("device.activeWLAN()")
        } else if device.activeWWAN() {
            println("device.activeWWAN()")
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName = ""
        
        switch section {
        case 0:
            sectionName = "커뮤니티"
            break;
        case 1:
            sectionName = "기타"
            break;
        default:
            sectionName = ""
            break;
        }
        
        return sectionName
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        if section == 0 {
            return noticeList.count
        } else if section == 1 {
            return commuList.count
        } else {
            return etcList.count
        }
        */
        if section == 0 {
            return commuList.count
        } else {
            return etcList.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: NSString = "titleViewCell"
        var cell: UITitleViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITitleViewCell
        
        /*
        if indexPath.section == 0 {
            cell.title.text = noticeList[indexPath.row].title
        } else if indexPath.section == 1 {
            cell.title.text = commuList[indexPath.row].title
        } else {
            cell.title.text = etcList[indexPath.row].title
        }
        */
        
        if indexPath.section == 0 {
            cell.title.text = commuList[indexPath.row].title
        } else {
            cell.title.text = etcList[indexPath.row].title
        }
    
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BoardTableList" {
            var boardCtrl: UIBoardViewController = segue.destinationViewController as UIBoardViewController
            
            var myIndexPath :NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            tableView.deselectRowAtIndexPath(myIndexPath, animated: false)
            
            /*
            if myIndexPath.section == 0 {
                boardCtrl.link = noticeList[myIndexPath.row].link!
                boardCtrl.title = noticeList[myIndexPath.row].title!
                boardCtrl.boardTitle = noticeList[myIndexPath.row].title!
            } else if myIndexPath.section == 1 {
                boardCtrl.link = commuList[myIndexPath.row].link!
                boardCtrl.title = commuList[myIndexPath.row].title!
                boardCtrl.boardTitle = commuList[myIndexPath.row].title!
            } else {
                boardCtrl.link = etcList[myIndexPath.row].link!
                boardCtrl.title = etcList[myIndexPath.row].title!
                boardCtrl.boardTitle = etcList[myIndexPath.row].title!
            }
            */
            
            if myIndexPath.section == 0 {
//                boardCtrl.link = commuList[myIndexPath.row].link!
//                boardCtrl.title = commuList[myIndexPath.row].title!
//                boardCtrl.boardTitle = commuList[myIndexPath.row].title!
                boardCtrl.board = commuList[myIndexPath.row]
            } else {
//                boardCtrl.link = etcList[myIndexPath.row].link!
//                boardCtrl.title = etcList[myIndexPath.row].title!
//                boardCtrl.boardTitle = etcList[myIndexPath.row].title!
                boardCtrl.board = etcList[myIndexPath.row]
            }
        
        }
    }
}