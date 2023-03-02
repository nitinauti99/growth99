//
//  MultipleSelectionQuestionChoiceTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 02/03/23.
//

import UIKit

class MultipleSelectionQuestionChoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var questionnaireChoiceName: UILabel!
    @IBOutlet weak var questionnaireChoiceButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(patientQuestionChoices: PatientQuestionChoices, index: IndexPath, preSelected: Bool) {
        self.questionnaireChoiceName.text = patientQuestionChoices.choiceName
        self.questionnaireChoiceButton.isSelected = patientQuestionChoices.selected ?? false
        if preSelected == true {
            self.questionnaireChoiceButton.isSelected =  true
        }
    }
    
    @IBAction func buttonAction(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
}
