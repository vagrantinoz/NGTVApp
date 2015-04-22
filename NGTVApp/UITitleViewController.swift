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
        
        self.communityBoardList()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(146.0/255.0), blue: CGFloat(189.0/255.0), alpha: CGFloat(1.0))
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(objectsAndKeys: UIColor.whiteColor(), NSForegroundColorAttributeName,
         UIFont(name: "AppleSDGothicNeo-Bold", size: 18.0)!, NSFontAttributeName) as [NSObject : AnyObject]
        
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
        let cellIdentifier: String = "titleViewCell"
        var cell: UITitleViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITitleViewCell
        
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
            cell.title.text = commuList[indexPath.row].title as String
        } else {
            cell.title.text = etcList[indexPath.row].title as String
        }
    
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BoardTableList" {
            var boardCtrl: UIBoardViewController = segue.destinationViewController as! UIBoardViewController
            
            var myIndexPath :NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            tableView.deselectRowAtIndexPath(myIndexPath, animated: false)
            
            if myIndexPath.section == 0 {
                boardCtrl.board = commuList[myIndexPath.row]
            } else {
                boardCtrl.board = etcList[myIndexPath.row]
            }
        
        }
    }
    
    /** 
        나이스게임티비 게시판 목록 가져오는 부분
        communityList, etcList 부분만 가져온다(랭크감별단은 전 부분이 비밀글로 되어 있어서 제외시킴)
    */
    func communityBoardList() {
        let manager = AFURLSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        manager.responseSerializer = AFHTTPResponseSerializer()
        let request : NSMutableURLRequest = AFHTTPRequestSerializer().requestWithMethod("GET", URLString: BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/bbs/freeboard/list", parameters: nil, error: nil)
        
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
                    (self.commuList, self.etcList) = NGTVMainParser.communityBoardList(responseObject as! NSData)
                    
                    self.tableView.reloadData()
                }
            }
        })
        
        task.resume()
    }
}