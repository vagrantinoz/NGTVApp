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
    var page = 1
    var link = ""
    var boardTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.boardList = BoardParser.boardList(link, page: page)
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
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "BoardDetail" {
            var detailCtrl: UIBoardDetailViewController = segue.destinationViewController as UIBoardDetailViewController
            
            let myIndexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            let row = myIndexPath.row
            
            detailCtrl.link = self.boardList[row].link!
        }
    }
}