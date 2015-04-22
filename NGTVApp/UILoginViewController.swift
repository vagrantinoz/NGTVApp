//
//  UILoginViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 24..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit
import SwiftHTTP

class UILoginViewController : UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var passwd: UITextField!
    
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    var webData : NSMutableData = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var detail = BoardDetail()
        var commentList = Array<Comment>()
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        let alert = UIAlertView(title: "Test", message: "Test", delegate: nil, cancelButtonTitle: "NO", otherButtonTitles: "YES")
        
        alert.show()
    }
    @IBAction func login(sender: UIButton) {
        var sheet = UIActionSheet()
        sheet.addButtonWithTitle("Take Camera")
        sheet.addButtonWithTitle("Photo Labrary")
        sheet.addButtonWithTitle("Cancel")
        sheet.destructiveButtonIndex = 2
        sheet.cancelButtonIndex = 2
        sheet.delegate = self
        
        sheet.showInView(self.view)
    }
    
    @IBAction func doWrite(sender: AnyObject) {
        var imgList = NSMutableArray()
//        imgList.addObject(img.image!)
//        var content = "<p>는 훼이크고....</p><p>모바일 앱 용 게시판 처리 부분 테스트를 위해 자게를 더럽힐 수는 없으니 </p><p>게시물 하나만 실례하겠습니다...ㅠㅠ</p><p>#NGTVApp</p>"
//        NGTVHTTPUtil.doWrite("etc", title: "제안드립니다.", content: content, imgList: imgList, secret: "Y")
        
//        NGTVHTTPUtil.doCommentWrite("etc", boardNo: "537952", parentId: "673855", content: "아아아아아아아아")
        
//        NGTVHTTPUtil.doCommentDelete("etc", boardNo: "537952", commentId: "673852")
        
//        NGTVHTTPUtil.doRecommend("etc", boardNo: "537952")
        
//        NGTVHTTPUtil.doCommentRecommend("etc", commentId: "673855")
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 2 {
            return;
        } else {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            if buttonIndex == 0 {
                if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                }
            } else if buttonIndex == 1 {
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            }
            

            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        img.image = image
        imgBtn.setBackgroundImage(image, forState: UIControlState.Normal)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
