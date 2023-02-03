//
//  QuestionarieListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 24/01/23.
//

import UIKit

protocol AddNewQuestionarieTableViewCellDelegate: AnyObject {
    func isQuestionnaireSelection(cell: AddNewQuestionarieTableViewCell, index: IndexPath)
}

class AddNewQuestionarieTableViewCell: UITableViewCell {

    @IBOutlet private weak var questionnaireName: UILabel!
    @IBOutlet private weak var questionnaireID: UILabel!
    @IBOutlet private weak var questionnaireSelection: UIButton!
    @IBOutlet private weak var subView: UIView!

    var dateFormater : DateFormaterProtocol?
    weak var delegate: AddNewQuestionarieTableViewCellDelegate?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }
    
    func configureCell(questionarieVM: AddNewQuestionarieViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.QuestionarieDataAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.name
        self.questionnaireID.text = String(questionarieVM?.id ?? 0)
        indexPath = index
    }
    
    @IBAction func selectionButtonPressed(sender: UIButton) {
        if sender.isSelected {
            sender.setBackgroundImage(#imageLiteral(resourceName: "tickselected"), for: .normal)
        } else {
            sender.setBackgroundImage(#imageLiteral(resourceName: "tickdefault"), for:.normal)
        }
        sender.isSelected = !sender.isSelected

        //self.delegate?.isQuestionnaireSelection(cell: self, index: indexPath)
    }
}
