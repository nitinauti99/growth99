//
//  GRWebViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 12/01/23.
//

import UIKit
import WebKit

class GRWebViewController: UIViewController, WKNavigationDelegate {

    let webView = WKWebView()
    var activityIndicator: UIActivityIndicatorView!
    var webViewUrlString: String = String.blank
    var webViewTitle: String = String.blank

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = webViewTitle
        webView.frame = view.bounds
        webView.navigationDelegate = self
        
        let url = URL(string: webViewUrlString)!
        let urlRequest = URLRequest(url: url)
        
        webView.load(urlRequest)
        webView.allowsBackForwardNavigationGestures = true
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
