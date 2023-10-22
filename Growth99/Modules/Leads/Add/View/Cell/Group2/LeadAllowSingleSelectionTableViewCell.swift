//
//  LeadAllowSingleSelectionTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 15/10/23.
//

import UIKit

class LeadAllowSingleSelectionTableViewCell: UITableViewCell {
    @IBOutlet weak var questionnaireChoiceName: UILabel!
    @IBOutlet weak var questionnaireChoiceButton: UIButton!

    let allButtonTags = [Int]()

    var tagId: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(patientQuestionChoices: PatientQuestionChoices, index: IndexPath, preSelected: Bool, singleselection: Bool) {
        self.questionnaireChoiceName.text = patientQuestionChoices.choiceName
      //  tagId += 
    }
    
    @IBAction func buttonAction(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
}
