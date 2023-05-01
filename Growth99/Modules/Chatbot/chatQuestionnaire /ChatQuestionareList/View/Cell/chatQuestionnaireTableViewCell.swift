//
//  chatQuestionnaireTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import UIKit

protocol chatQuestionnaireTableViewCellDelegate: AnyObject {
    func removeChatQuestionnaire(cell: chatQuestionnaireTableViewCell, index: IndexPath)
    func editChatQuestionnaire(cell: chatQuestionnaireTableViewCell, index: IndexPath)
}

class chatQuestionnaireTableViewCell: UITableViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedAt: UILabel!
    @IBOutlet private weak var updatedBy: UILabel!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet weak var editButtonAction: UIButton!

    var dateFormater: DateFormaterProtocol?
    weak var delegate: chatQuestionnaireTableViewCellDelegate?

    var indexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }

    func configureCellisSearch(chatQuestionnaire: chatQuestionnaireViewModelProtocol?, index: IndexPath) {
        let chatQuestionnaire = chatQuestionnaire?.chatQuestionnaireFilterDataAtIndex(index: index.row)
        self.name.text = chatQuestionnaire?.name
        self.createdBy.text = chatQuestionnaire?.createdBy?.firstName
        self.createdAt.text = dateFormater?.serverToLocal(date: chatQuestionnaire?.createdAt ?? String.blank)
        self.updatedAt.text =  dateFormater?.serverToLocal(date: chatQuestionnaire?.updatedAt ?? String.blank)
        self.updatedBy.text =  chatQuestionnaire?.updatedBy?.firstName
        indexPath = index
    }
    
    func configureCell(chatQuestionnaire: chatQuestionnaireViewModelProtocol?, index: IndexPath) {
        let chatQuestionnaire = chatQuestionnaire?.chatQuestionnaireDataAtIndex(index: index.row)
        self.name.text = chatQuestionnaire?.name
        self.createdBy.text = chatQuestionnaire?.createdBy?.firstName
        self.createdAt.text = dateFormater?.serverToLocal(date: chatQuestionnaire?.createdAt ?? String.blank)
        self.updatedAt.text =  dateFormater?.serverToLocal(date: chatQuestionnaire?.updatedAt ?? String.blank)
        self.updatedBy.text =  chatQuestionnaire?.updatedBy?.firstName
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeChatQuestionnaire(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editChatQuestionnaire(cell: self, index: indexPath)
    }
    
    
}
