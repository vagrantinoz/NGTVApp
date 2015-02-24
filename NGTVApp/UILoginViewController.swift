//
//  UILoginViewController.swift
//  NGTVApp
//
//  Created by lunafei on 2015. 2. 24..
//  Copyright (c) 2015년 lunafei. All rights reserved.
//

import UIKit

class UILoginViewController : UIViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    var currentDetailViewController : UIViewController?
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var passwd: UITextField!
    
    var webData : NSMutableData = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentDetailViewController = UILoginViewController()
    }
    
    @IBAction func login(sender: UIButton) {

        var post = NSString(format: "userId=\(id.text!)&userPw=\(passwd.text!)")
        var postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        var url = NSURL(string: "http://www.nicegame.tv/user/doLogin")
        var postLength = NSString(string: "\(postData?.length)")
        
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postData
        
        let connection = NSURLConnection(request: request, delegate: self)
        
        if (connection != nil) {
//            println("running.....")
        } else {
//            println("Internet problem....")
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        webData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        var loginStatus = NSString(bytes: self.webData.mutableBytes, length: webData.length, encoding: NSUTF8StringEncoding)
        
        println(loginStatus)
    }
}
