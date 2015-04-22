//
//  BoardWriteViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 3. 8..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit
//import SwiftHTTP

class BoardWriteViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate {
    
    @IBOutlet var nav: UINavigationBar!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var contentField: UITextView!
    @IBOutlet var bottomBar: UIToolbar!
    
    var imgArr = NSMutableArray()
    var image1 :UIImage?
//    var image2 :UIImage?
//    var image3 :UIImage?
    
    var boardId = ""
    
    var _title = ""
    var _content = ""
    var _secret = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelBtn = UIBarButtonItem(title: "취소", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("closeView"))
        let confirmBtn = UIBarButtonItem(title: "완료", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("confirmView"))
        
        var navItem = UINavigationItem(title: "테스트 타이틀")
        navItem.leftBarButtonItem = cancelBtn
        navItem.rightBarButtonItem = confirmBtn
        nav.pushNavigationItem(navItem, animated: true)
        
        println(boardId)
        
    }
    
    func closeView() {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func confirmView() {
        self._title = titleField.text!
        self._content = contentField.text!
        self._secret = "Y"
        
        if self._title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            var alert = UIAlertView(title: "등록실패", message: "제목을 입력하십시오", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return;
        }
        
        if self._content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
            var alert = UIAlertView(title: "등록실패", message: "내용을 입력하십시오", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return;
        }
        
        
        
        //NGTVHTTPUtil.doWrite(self.boardId, title: title, content: convertContent, imgList: NSArray(), secret: "Y")
        
        var confirmWrite = UIAlertView(title: "등록", message: "글을 등록하시겠습니까?", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "Cancel")
        confirmWrite.show()
        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println(buttonIndex)
        if buttonIndex == 0 {
            let splitContent = self._content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            
            var convertContent = ""
            
            for split in splitContent {
                convertContent += "<p>\(split)</p>"
            }

            var params = [
                "articleId": "",
                "isNotSupport" : "1",
                "secret" : self._secret,
                "title": self._title,
                "content" : convertContent
            ]
            
            let url = BaseData.sharedInstance.NICEGAMETV_ADDRESS + "/bbs/" + self.boardId + "/doWrite"
            
            var request = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: url, parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
                formData.appendPartWithFormData(self._title.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "title")
                formData.appendPartWithFormData(self._secret.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "secret")
                formData.appendPartWithFormData(self._content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "content")
                formData.appendPartWithFormData("".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "articleId")
                formData.appendPartWithFormData("1".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "isNotSupport")
                
                // 차후 이미지 등록을 체크해서 빈 데이터가 아닌 이미지 데이터로 전환할 수 있도록 수정할것
                if let img1 = self.image1 {
                    let tmpImg1 = img1 as UIImage
                    
                    var data = UIImageJPEGRepresentation(tmpImg1, CGFloat(0.9))
                    formData.appendPartWithFileData(data, name: "attach1", fileName: "image1.jpg", mimeType: "image/jpg")
                } else {
                   formData.appendPartWithFileData("".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "attach1", fileName: "", mimeType: "")
                }
                
                formData.appendPartWithFileData("".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "attach2", fileName: "", mimeType: "")
                formData.appendPartWithFileData("".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), name: "attach3", fileName: "", mimeType: "")
                
            }, error: nil)
            
            let manager = AFHTTPSessionManager(sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
            manager.responseSerializer = AFHTTPResponseSerializer()
            
            let task = manager.dataTaskWithRequest(request, completionHandler: { (response: NSURLResponse!, responseObject:AnyObject!, error:NSError!) -> Void in
                if((error) != nil) {
                    println(error.localizedDescription)
                } else {
                    let responseCode = (response as? NSHTTPURLResponse)?.statusCode ?? -1
                    
                    // responseCode 200이 아닐경우(200이 아니면 정상적인 페이지 로딩이 아니다)
                    if (responseCode != 200) {
                        let alert = UIAlertView(title: "502오류", message: "502 GateError가 발생하였습니다. 앱 종료 후 다시 시도해 주십시오", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    } else {
                        println(NSString(data: responseObject as! NSData, encoding: NSUTF8StringEncoding))
                        self.view.endEditing(true)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            })
            
            task.resume()
//            self.view.endEditing(true)
//            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
//        let imageKey = "image\(imgArr.count)"
//        var dic = NSDictionary(object: image, forKey: imageKey)
        
        if bottomBar.items?.count == 2 {
            bottomBar.items?.removeAtIndex(1)
        }
        
        var btn = UIBarButtonItem(title: "image1", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("deleteImage1"))
        
        bottomBar.items?.append(btn)
        
        
        
//        self.image1 = self.rotateImage(image)
        self.image1 = image

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    func rotateImage(image : UIImage) -> UIImage {
        let imgRef = image.CGImage;
        let orient = image.imageOrientation
        let width = CGFloat(CGImageGetWidth(imgRef));
        let height = CGFloat(CGImageGetHeight(imgRef));
        var bounds = CGRectMake(0, 0, width, height);
        
        var transform = CGAffineTransformIdentity;
        let imageSize = CGSizeMake(CGFloat(CGImageGetWidth(imgRef)), CGFloat(CGImageGetHeight(imgRef)));
        var boundHeight : CGFloat!
        switch(orient) {
        case UIImageOrientation.Up :        // EXIF = 1
            transform = CGAffineTransformIdentity
            break;
            
        case UIImageOrientation.UpMirrored : // EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0)
            transform = CGAffineTransformScale(transform, -1.0, 1.0)
            break;
            
        case UIImageOrientation.Down : // EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            break;
            
        case UIImageOrientation.DownMirrored : // EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height)
            transform = CGAffineTransformScale(transform, 1.0, -1.0)
            break;
            
        case UIImageOrientation.LeftMirrored : // EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width)
            transform = CGAffineTransformScale(transform, -1.0, 1.0)
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0)
            break;
            
        case UIImageOrientation.Left : // EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width)
            transform = CGAffineTransformRotate(transform, 3.0 * CGFloat(M_PI) / 2.0)
            break;
            
        case UIImageOrientation.RightMirrored :  // EXIF = 7
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransformMakeScale(-1.0, 1.0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0)
            break;
            
        case UIImageOrientation.Right :
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 2.0)
            break;
            
        default:
            break;
            
        }
        
        UIGraphicsBeginImageContext(bounds.size);
        
        let context = UIGraphicsGetCurrentContext();
        
        if (orient == UIImageOrientation.Right || orient == UIImageOrientation.Left) {
            CGContextTranslateCTM(context, -height, 0);
        }
        else {
            CGContextTranslateCTM(context, 0, -height);
        }
        
        CGContextConcatCTM(context, transform);
        
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return imageCopy;
    }
    
    func deleteImage1() {
        image1 = nil
        bottomBar.items?.removeAtIndex(1)
    }
}