//
//  ChatBotTemplateViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 11/03/23.
//

import Foundation
import UIKit
import WebKit

protocol ChatBotTemplateViewControllerProtocol {
    func errorReceived(error: String)
    func chatBotTemplateListReceivedSuccefully()
}

class ChatBotTemplateViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ChatBotTemplateViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ChatBotTemplateViewModel(delegate: self)
        webView.navigationDelegate = self
        self.tableView.register(UINib(nibName: "ChatBotTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatBotTemplateTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getChatBotTemplateList()
    }
}

extension ChatBotTemplateViewController: ChatBotTemplateViewControllerProtocol {
   
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func chatBotTemplateListReceivedSuccefully() {
        self.view.HideSpinner()
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: self.viewModel?.getChatDefaultBotTemplateData?.previewIframeUrl ?? "") else { return }
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url))
                self.webView.allowsBackForwardNavigationGestures = true

            }
        }
         self.tableView.reloadData()
    }
}
