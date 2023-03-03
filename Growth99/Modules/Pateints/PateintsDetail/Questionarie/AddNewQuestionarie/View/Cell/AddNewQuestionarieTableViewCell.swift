//
//  QuestionarieListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 24/01/23.
//

import UIKit

class AddNewQuestionarieTableViewCell: UITableViewCell {

    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var questionnaireID: UILabel!
    @IBOutlet weak var questionnaireSelection: UIButton!
    @IBOutlet weak var subView: UIView!

    var dateFormater : DateFormaterProtocol?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }
    
    func configureCell(questionarieVM: AddNewQuestionarieViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.questionarieDataAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.name
        self.questionnaireID.text = String(questionarieVM?.id ?? 0)
        indexPath = index
    }
    
    func configureCellWithSearch(questionarieVM: AddNewQuestionarieViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.questionarieFilterDataAtIndex(index: index.row)
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
    }
}
