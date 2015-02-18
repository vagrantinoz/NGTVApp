//
//  UIBoardDetailViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 18..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class UIBoardDetailViewController : UIViewController {
    var boardDetail = BoardDetail()
    var commentList = Array<Comment>()
    var link = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardDetail = BoardParser.boardDetail(link)
        commentList = BoardParser.commentList(link)
        
        println(boardDetail)
    }
}