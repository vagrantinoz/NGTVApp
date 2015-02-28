//
//  UITitleViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 18..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit
class UITitleViewController : UITableViewController {
    var titleList = Array<BoardTitle>()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NGTVHTTPUtil.login("miharing", passwd: "wlgnsdja01")
        titleList = NGTVMainParser.communityBoardList()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: NSString = "titleViewCell"
        var cell: UITitleViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITitleViewCell
        
        let row = indexPath.row
        
        cell.title.text = titleList[row].title
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BoardTableList" {
            var boardCtrl: UIBoardViewController = segue.destinationViewController as UIBoardViewController
            
            var myIndexPath :NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            tableView.deselectRowAtIndexPath(myIndexPath, animated: false)
            
            var row = myIndexPath.row
            
            boardCtrl.link = titleList[row].link!
            boardCtrl.title = titleList[row].title!
            boardCtrl.boardTitle = titleList[row].title!
        }
    }
}