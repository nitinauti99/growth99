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
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Help Center"
        webView.frame = view.bounds
        webView.navigationDelegate = self
        /// change prodcution url
        if let url = URL(string: "https://support.growth99.com/portal/en/kb/growth99plus-articles-and-video-trainings") {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
            webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            view.addSubview(webView)
        } else {
            print("Invalid URL")
        }
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

