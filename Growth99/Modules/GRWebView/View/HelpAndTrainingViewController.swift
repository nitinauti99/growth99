//
//  HelpAndTrainingViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 23/05/23.
//

import Foundation

import UIKit
import WebKit

class HelpAndTrainingViewController: UIViewController, WKNavigationDelegate {
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.frame = view.bounds
        webView.navigationDelegate = self
        
        let url = URL(string: "https://support.growth99.com/portal/en/kb/growth99-plus")!
        let urlRequest = URLRequest(url: url)
        
        webView.load(urlRequest)
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(webView)
    }
    
}

