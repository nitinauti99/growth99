//
//  MultipleSelectionWithDropDownTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 29/12/22.
//

import UIKit

protocol LeadMultipleSelectionWithDropDownTypeTableViewCellDelegate: AnyObject {
    func showDropDownQuestionchoice(cell: LeadMultipleSelectionWithDropDownTypeTableViewCell, index: IndexPath)
}

class LeadMultipleSelectionWithDropDownTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var dropDownTypeTextField: CustomTextField!
    @IBOutlet weak var dropDownButton: UIButton!
//    @IBOutlet weak var asteriskSign: UILabel!

    var patientQuestionChoices = [PatientQuestionChoices]()
    var indexPath = IndexPath()
    weak var delegate: LeadMultipleSelectionWithDropDownTypeTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(questionarieVM: CreateLeadViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.getLeadQuestionnaireListAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.questionName
        self.dropDownTypeTextField.text = questionarieVM?.patientQuestionChoices?[0].choiceName ?? ""
        self.indexPath = index
//        self.asteriskSign.isHidden = true
//        if questionarieVM?.required == true {
//            self.asteriskSign.isHidden = false
//        }
    }
    
    @IBAction func dropDownButton(sender: UIButton){
        delegate?.showDropDownQuestionchoice(cell: self, index: indexPath)
    }
}
