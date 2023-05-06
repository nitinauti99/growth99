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
    var webViewUrl: URL!
    var webViewTitle: String = String.blank

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        self.title = webViewTitle
        loadWebviewUrl()
    }
    
    func loadWebviewUrl() {
        let url = URL(string: "https://support.growth99.com/portal/en/kb/growth99-plus")!
        let request = URLRequest(url: url)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        webView.isExclusiveTouch = true
    }
}
