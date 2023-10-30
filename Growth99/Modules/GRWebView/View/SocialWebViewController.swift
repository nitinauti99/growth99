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
    
    var webView = WKWebView()
    var activityIndicator: UIActivityIndicatorView!
    var userSocialType: String = ""
    var userSocialUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = userSocialType
        webView = WKWebView() // Assuming you're using WKWebView
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        // Create Auto Layout constraints
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Load the URL
        if let url = URL(string: userSocialUrl) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
        
        // Create and configure the activity indicator
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
                    let userInfo = [ "accessToken" : accessToken, "SocialType": userSocialType ]
                    NotificationCenter.default.post(name: Notification.Name("AccessTokenReceived"), object: nil, userInfo: userInfo)
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                if urlStr.contains("access_token=") {
                    let components = urlStr.components(separatedBy: "=")
                    let components1 = components[1].components(separatedBy: "&")
                    let accessToken = components1[0]
                    let userInfo = [ "accessToken" : accessToken, "SocialType": userSocialType ]
                    NotificationCenter.default.post(name: Notification.Name("AccessTokenReceived"), object: nil, userInfo: userInfo)
                    self.navigationController?.popViewController(animated: true)
                } else if urlStr.contains("error=") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        decisionHandler(.allow)
    }
}


