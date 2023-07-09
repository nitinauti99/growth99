//
//  UnansweredQuestionListTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import UIKit

class UnansweredQuestionListTableViewCell: UITableViewCell {
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var question: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var subView: UIView!

    var dateFormater: DateFormaterProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }

    func configureCellisSearch(unansweredQuestionList: UnansweredQuestionListViewModelProtocol?, index: IndexPath) {
        let chatSessionList = unansweredQuestionList?.getUnansweredQuestionListFilterDataAtIndex(index: index.row)
        self.id.text = String(chatSessionList?.id ?? 0)
        self.question.text = chatSessionList?.question
        self.createdDate.text =  dateFormater?.serverToLocalDateConverter(date: chatSessionList?.createdAt ?? String.blank)
    }
    
    func configureCell(unansweredQuestionList: UnansweredQuestionListViewModelProtocol?, index: IndexPath) {
        let chatSessionList = unansweredQuestionList?.getUnansweredQuestionListDataAtIndex(index: index.row)
        self.id.text = String(chatSessionList?.id ?? 0)
        self.question.text = chatSessionList?.question
        self.createdDate.text =  dateFormater?.serverToLocalDateConverter(date: chatSessionList?.createdAt ?? String.blank)
    }
    
}

