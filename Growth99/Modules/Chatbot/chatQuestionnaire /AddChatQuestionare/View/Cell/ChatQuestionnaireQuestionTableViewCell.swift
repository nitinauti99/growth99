//
//  ChatQuestionnaireQuestionTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 07/03/23.
//

import UIKit

protocol ChatQuestionnaireQuestionTableViewCellDelegate: AnyObject {
    func removeChatQuestionnaireQuestion(cell: ChatQuestionnaireQuestionTableViewCell, index: IndexPath)
    func editChatQuestionnaireQuestion(cell: ChatQuestionnaireQuestionTableViewCell, index: IndexPath)

}

class ChatQuestionnaireQuestionTableViewCell: UITableViewCell {

    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedAt: UILabel!
    @IBOutlet private weak var updatedBy: UILabel!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet weak var editButtonAction: UIButton!

    var dateFormater: DateFormaterProtocol?
    weak var delegate: ChatQuestionnaireQuestionTableViewCellDelegate?

    var indexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }

    func configureCellisSearch(chatQuestionnaire: CreateChatQuestionareViewModelProtocol?, index: IndexPath) {
        let chatQuestionnaire = chatQuestionnaire?.chatQuestionnaireQuestionFilterDataAtIndex(index: index.row)
        self.name.text = chatQuestionnaire?.question
        self.createdBy.text = chatQuestionnaire?.createdBy?.firstName
        self.createdAt.text = dateFormater?.serverToLocalDateConverter(date: chatQuestionnaire?.createdAt ?? String.blank)
        self.updatedAt.text =  dateFormater?.serverToLocalDateConverter(date: chatQuestionnaire?.updatedAt ?? String.blank)
        self.updatedBy.text =  chatQuestionnaire?.updatedBy?.firstName
        indexPath = index
    }
    
    func configureCell(chatQuestionnaire: CreateChatQuestionareViewModelProtocol?, index: IndexPath) {
        let chatQuestionnaire = chatQuestionnaire?.chatQuestionnaireQuestionDataAtIndex(index: index.row)
        self.name.text = chatQuestionnaire?.question
        self.createdBy.text = chatQuestionnaire?.createdBy?.firstName
        self.createdAt.text = dateFormater?.serverToLocalDateConverter(date: chatQuestionnaire?.createdAt ?? String.blank)
        self.updatedAt.text =  dateFormater?.serverToLocalDateConverter(date: chatQuestionnaire?.updatedAt ?? String.blank)
        self.updatedBy.text =  chatQuestionnaire?.updatedBy?.firstName
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeChatQuestionnaireQuestion(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editChatQuestionnaireQuestion(cell: self, index: indexPath)
    }
}
