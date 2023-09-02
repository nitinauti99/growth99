//
//  SocialWebViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 23/05/23.
//

import Foundation

import UIKit
import WebKit

class SocialWebViewController: UIViewController {
    
    let webView = WKWebView()
    var activityIndicator: UIActivityIndicatorView!
    var userSocialType: String = ""
    var userSocialUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = userSocialType
        webView.frame = view.bounds
        webView.navigationDelegate = self
        
        let url = URL(string: userSocialUrl)!
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
    
}


extension SocialWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if userSocialType == "Linkedin" {
                if urlStr.contains("code=") {
                    let components = urlStr.components(separatedBy: "=")
                    let components1 = components[1].components(separatedBy: "&")
                    let accessToken = components1[0]
                    print("Access Token: \(accessToken)")
                    let userInfo = [ "accessToken" : accessToken, "SocialType": userSocialType ]
                    NotificationCenter.default.post(name: Notification.Name("AccessTokenReceived"), object: nil, userInfo: userInfo)
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                if urlStr.contains("access_token=") {
                    let components = urlStr.components(separatedBy: "=")
                    let components1 = components[1].components(separatedBy: "&")
                    let accessToken = components1[0]
                    print("Access Token: \(accessToken)")
                    let userInfo = [ "accessToken" : accessToken, "SocialType": userSocialType ]
                    NotificationCenter.default.post(name: Notification.Name("AccessTokenReceived"), object: nil, userInfo: userInfo)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        decisionHandler(.allow)
    }
}


