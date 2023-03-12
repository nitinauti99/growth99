//
//  ChatSessionListTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 10/03/23.
//

import UIKit

class ChatSessionListTableViewCell: UITableViewCell {
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var phoneNumber: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var subView: UIView!

    var dateFormater: DateFormaterProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }

    func configureCellisSearch(chatSessionList: ChatSessionListViewModelProtocol?, index: IndexPath) {
        let chatSessionList = chatSessionList?.getChatSessionListFilterDataAtIndex(index: index.row)
        self.id.text = String(chatSessionList?.id ?? 0)
        self.name.text = chatSessionList?.firstName?.appending(" \(chatSessionList?.firstName ?? "")")
        self.email.text = chatSessionList?.email
        self.phoneNumber.text = chatSessionList?.phone
        self.createdDate.text =  dateFormater?.serverToLocal(date: chatSessionList?.createdAt ?? String.blank)
    }
    
    func configureCell(chatSessionList: ChatSessionListViewModelProtocol?, index: IndexPath) {
        let chatSessionList = chatSessionList?.getChatSessionListDataAtIndex(index: index.row)
        self.id.text = String(chatSessionList?.id ?? 0)
        self.name.text = chatSessionList?.firstName?.appending(" \(chatSessionList?.firstName ?? "")")
        self.email.text = chatSessionList?.email
        self.phoneNumber.text = chatSessionList?.phone
        self.createdDate.text =  dateFormater?.serverToLocal(date: chatSessionList?.createdAt ?? String.blank)
    }
}
