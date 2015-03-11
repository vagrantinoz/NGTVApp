//
//  BoardWriteViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 3. 8..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class BoardWriteViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate {
    
    @IBOutlet var nav: UINavigationBar!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var contentField: UITextView!
    @IBOutlet var bottomBar: UIToolbar!
    
    var imgArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelBtn = UIBarButtonItem(title: "취소", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("closeView"))
        let confirmBtn = UIBarButtonItem(title: "완료", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("confirmView"))
        
        var navItem = UINavigationItem(title: "테스트 타이틀")
        navItem.leftBarButtonItem = cancelBtn
        navItem.rightBarButtonItem = confirmBtn
        nav.pushNavigationItem(navItem, animated: true)
        
    }
    
    func closeView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func confirmView() {
        println("confirnView")
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func showCameraRoll(sender: AnyObject) {
        var sheet = UIActionSheet()
        sheet.addButtonWithTitle("Take Camera")
        sheet.addButtonWithTitle("Photo Labrary")
        sheet.addButtonWithTitle("Cancel")
        sheet.destructiveButtonIndex = 2
        sheet.cancelButtonIndex = 2
        sheet.delegate = self
        
        sheet.showInView(self.view)
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
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        let imageKey = "image\(imgArr.count)"
        
        var dic = NSDictionary(object: image, forKey: imageKey)
        
        bottomBar.items?.append(UIBarButtonItem(title: "완료", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("confirmView")))

        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteImage1(sender: AnyObject) {
        println("DeleteImage1")
    }
    
    @IBAction func deleteImage2(sender: AnyObject) {
        println("DeleteImage2")
    }
    
    @IBAction func deleteImage3(sender: AnyObject) {
        println("DeleteImage3")
    }
    
}