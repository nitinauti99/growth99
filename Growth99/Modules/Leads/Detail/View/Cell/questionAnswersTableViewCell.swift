//
//  questionAnswersTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 30/12/22.
//

import UIKit

protocol questionAnswersTableViewCellDelegate: AnyObject {
    func editButtonPressed(cell: questionAnswersTableViewCell)
}

class questionAnswersTableViewCell: UITableViewCell {
    @IBOutlet weak var qutionNameLbi: UILabel!
    @IBOutlet weak var ansLbi: UILabel!
    @IBOutlet weak var editButton: UIButton!

    weak var delegate: questionAnswersTableViewCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func cnfigureCell(viewModel: leadDetailViewProtocol?, index: IndexPath){
        let patientQuestionList = viewModel?.getQuestionnaireDetailList(index: index.row)
        self.editButton.isHidden = true
        self.qutionNameLbi.text = patientQuestionList?.questionName
        self.ansLbi.text = patientQuestionList?.answerText
        
        if patientQuestionList?.answerText == nil {
            self.ansLbi.text = "-"
        }
        if patientQuestionList?.questionName == "Email" {
            UserRepository.shared.primaryEmailId = patientQuestionList?.answerText
        }
        
        if patientQuestionList?.questionName == "First Name" || patientQuestionList?.questionName == "Last Name" || patientQuestionList?.questionName == "Email" || patientQuestionList?.questionName == "Phone Number" {
            self.editButton.isHidden = false
            let image = UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate)
            self.editButton.setImage(image, for: .normal)
            self.editButton.tintColor = UIColor.init(hexString: "009EDE")
        }
    }
    
    @IBAction func editButtonPressed(sender: UIButton) {
        self.delegate?.editButtonPressed(cell: self)
    }
    
}
