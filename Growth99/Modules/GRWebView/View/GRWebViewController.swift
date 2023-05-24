//
//  GRWebViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 12/01/23.
//

import UIKit
import WebKit

class GRWebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet private weak var webView: WKWebView!
    var webViewUrlString: String = String.blank
    var webViewTitle: String = String.blank

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        self.title = webViewTitle
        self.loadWebviewUrl()
    }
    
    func loadWebviewUrl() {
        if let url = URL (string: self.webViewUrlString) {
            let request = URLRequest(url: url)
            self.webView.load(request)
            webView.allowsBackForwardNavigationGestures = true
            webView.isExclusiveTouch = true
        }
    }
}
