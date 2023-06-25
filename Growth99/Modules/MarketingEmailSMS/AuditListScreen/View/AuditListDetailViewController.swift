//
//  AuditListDetailViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 26/06/23.
//

import Foundation

import UIKit
import WebKit

class AuditListDetailViewController: UIViewController, WKNavigationDelegate {
    
    let webView = WKWebView()
    var activityIndicator: UIActivityIndicatorView!
    var urlContentInfo: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Help Center"
        webView.frame = view.bounds
        webView.navigationDelegate = self
        
        guard let url = URL(string: urlContentInfo) else {
            return
        }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(webView)
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
}

