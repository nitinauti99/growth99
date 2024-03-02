//
//  UpgradeTwoWayTextViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 24/12/23.
//

import Foundation
import UIKit
import WebKit

class UpgradeTwoWayTextViewController: UIViewController {
    var viewModel: TwoWayTextConfigurationViewModelProtocol?
    @IBOutlet weak var webView: WKWebView!
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Configuration"
        webView.configuration.userContentController.addUserScript(self.getZoomDisableScript())
        /// dev url https://devemr.growthemr.com/two-way-text/public/subscribe?bid=
        /// prod url   https://app.growth99.com/two-way-text/public/subscribe?bid=
        let url = URL(string: "https://app.growth99.com/two-way-text/public/subscribe?bid=\(UserRepository.shared.Xtenantid ?? String.blank)")
        var request = URLRequest(url: url! as URL)
        request.setValue("Content-Type", forHTTPHeaderField: "application/json")
        request.setValue("authorization "+(UserRepository.shared.authToken ?? String.blank), forHTTPHeaderField: "Bearer "+(UserRepository.shared.authToken ?? String.blank))
        webView.load(request)
    }
    
    private func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
}
