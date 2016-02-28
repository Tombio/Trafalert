//
//  InfoViewController.swift
//  Trafalert
//
//  Created by Tomi Lahtinen on 03/05/15.
//  Copyright (c) 2015 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

class InfoViewController: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewWillAppear(animated: Bool) {
        webView.delegate = self
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let localfilePath = NSBundle.mainBundle().URLForResource("Legal", withExtension: "html");
        let request = NSURLRequest(URL: localfilePath!);
        webView.loadRequest(request);
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
}