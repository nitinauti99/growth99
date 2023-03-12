//
//  ChatBotTemplateViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 11/03/23.
//

import Foundation
import UIKit
import WebKit
import SafariServices

protocol ChatBotTemplateViewControllerProtocol {
    func errorReceived(error: String)
    func chatBotTemplateListReceivedSuccefully()
    func setChatBotTemplateSuccefully()
}

class ChatBotTemplateViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var preViewButton: UIButton!

    @IBOutlet weak var mainViewHight: NSLayoutConstraint!

    var viewModel: ChatBotTemplateViewModelProtocol?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ChatBotTemplateViewModel(delegate: self)
        webView.navigationDelegate = self
        self.tableView.register(UINib(nibName: "ChatBotTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatBotTemplateTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.preViewButton.createBorderForView(color: .white, redius: 10, width: 1)
        self.view.ShowSpinner()
        self.viewModel?.getChatBotTemplateList()
    }
    
    @IBAction func preViewButtonPressed(sender: UIButton){
        guard let url = URL(string: self.viewModel?.getChatDefaultBotTemplateData?.appPreviewUrl ?? "") else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
}

extension ChatBotTemplateViewController: ChatBotTemplateViewControllerProtocol {
   
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func scrollViewHeight() {
        self.mainViewHight.constant = CGFloat(((self.viewModel?.getChatBotTemplateListData.count ?? 0) * 700) + 600)
    }
    
    func chatBotTemplateListReceivedSuccefully() {
        self.view.HideSpinner()
        self.removewWebViewCache()
            DispatchQueue.main.async {
                guard let url = URL(string: self.viewModel?.getChatDefaultBotTemplateData?.previewIframeUrl ?? "") else { return }
                self.webView.load(URLRequest(url: url))
                self.webView.allowsBackForwardNavigationGestures = true
                self.tableView.reloadData()
                self.scrollViewHeight()
           }
      }
    
    func removewWebViewCache(){
        URLCache.shared.removeAllCachedResponses()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    func setChatBotTemplateSuccefully(){
        self.view.ShowSpinner()
        self.viewModel?.getChatBotTemplateList()
    }
}

extension ChatBotTemplateViewController: ChatBotTemplateTableViewCellDelegate {
    
    func setDefaultChatBotTemplate(cell: ChatBotTemplateTableViewCell, index: IndexPath) {
        let item = self.viewModel?.getChatBotTemplateListDataAtIndex(index: index.row)
        let param: [String: Any] = [
            "deleted": item?.deleted ?? false,
            "tenantId": item?.tenantId ?? 0,
            "id": item?.id ?? 0,
            "chatBotId": item?.chatBotId ?? 0,
            "name": item?.name ?? "",
            "code": item?.code ?? "",
            "isDefault": false,
            "defaultTemplate": true,
            "active": true,
            "isCustom": item?.isCustom ?? "",
            "isChatbotStatic": false,
        ]
        self.view.ShowSpinner()
        viewModel?.setChatBotTemplateDeault(templateId: item?.id ?? 0, param: param)
    }
    
    func preViewDefaultChatBotTemplate(cell: ChatBotTemplateTableViewCell, index: IndexPath) {
        let item = self.viewModel?.getChatBotTemplateListDataAtIndex(index: index.row)
        guard let url = URL(string: item?.appPreviewUrl ?? "") else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
}

extension ChatBotTemplateViewController: UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
        scrollViewHeight()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
}

