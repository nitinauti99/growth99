//
//  ChatBotTemplateTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 11/03/23.
//

import UIKit
import WebKit

class ChatBotTemplateTableViewCell: UITableViewCell {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var makeDefaultButton: UIButton!
    @IBOutlet weak var preViewButton: UIButton!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var subViewTop: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        self.subViewTop.createBorderForView(redius: 8, width: 1)
        self.subViewTop.addBottomShadow(color: .gray)
        self.makeDefaultButton.createBorderForView(color: Color(hexString: "009EDE"), redius: 10, width: 1)
        self.preViewButton.createBorderForView(color: Color(hexString: "009EDE"), redius: 10, width: 1)

    }

    func configureCell(chatBotTemplateList: ChatBotTemplateViewModelProtocol?, index: IndexPath) {
        let chatBotTemplateList = chatBotTemplateList?.getChatBotTemplateListDataAtIndex(index: index.row)
        DispatchQueue.main.async {
            guard let url = URL(string: chatBotTemplateList?.previewIframeUrl ?? "") else {return}
            self.webView.load(URLRequest(url: url))

        }
    }
    
    
    
}
