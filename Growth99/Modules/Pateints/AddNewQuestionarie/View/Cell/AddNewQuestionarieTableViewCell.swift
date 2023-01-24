//
//  QuestionarieListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 24/01/23.
//

import UIKit

class AddNewQuestionarieTableViewCell: UITableViewCell {

    @IBOutlet private weak var questionnaireName: UILabel!
    @IBOutlet private weak var questionnaireID: UILabel!
    @IBOutlet private weak var questionnaireSelection: UILabel!
    @IBOutlet private weak var subView: UIView!

    var dateFormater : DateFormaterProtocol?
    
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
       // self.questionnaireSelection.text = questionarieVM?.questionnaireStatus
    }
}
