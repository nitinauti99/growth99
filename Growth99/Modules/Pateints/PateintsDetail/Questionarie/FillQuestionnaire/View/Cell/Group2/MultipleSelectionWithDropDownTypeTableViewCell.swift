//
//  MultipleSelectionWithDropDownTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 29/12/22.
//

import UIKit

protocol MultipleSelectionWithDropDownTypeTableViewCellDelegate: AnyObject {
    func showDropDownQuestionchoice(cell: MultipleSelectionWithDropDownTypeTableViewCell, index: IndexPath)
}

class MultipleSelectionWithDropDownTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var dropDownTypeTextField: CustomTextField!
    @IBOutlet weak var dropDownButton: UIButton!
    var patientQuestionChoices = [PatientQuestionChoices]()
    var indexPath = IndexPath()
    weak var delegate: MultipleSelectionWithDropDownTypeTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(questionarieVM: FillQuestionarieViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.getQuestionnaireListAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.questionName
        self.dropDownTypeTextField.text = questionarieVM?.patientQuestionChoices?[0].choiceName ?? ""
        self.indexPath = index
    }
    
    @IBAction func dropDownButton(sender: UIButton){
        delegate?.showDropDownQuestionchoice(cell: self, index: indexPath)
    }
}
