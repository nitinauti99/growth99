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
    var allButtonTags = [Int]()
    var buttons = [UIButton]()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(patientQuestionChoices: PatientQuestionChoices, index: IndexPath, preSelected: Bool, tagid: [UIButton]) {
        self.questionnaireChoiceName.text = patientQuestionChoices.choiceName
        self.questionnaireChoiceButton.tag = patientQuestionChoices.choiceId ?? 0
        buttons = tagid
//        if let button = self.contentView.subviews.first?.viewWithTag(patientQuestionChoices.choiceId ?? 0) as? UIButton {
//            self.buttons.append(button)
//        }

        print("allButtonTags", patientQuestionChoices.choiceId ?? 0)
    }
    
    @IBAction func buttonAction(sender: UIButton){
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        
//        for tagid in allButtonTags {
//            /// getting current button from memory prevois clear from it
//            if let button = self.contentView.subviews.first?.viewWithTag(tagid) as? UIButton {
//                button.isSelected = false
//            }
//            if tagid == sender.tag {
//                if sender.isSelected ==  true {
//                    sender.isSelected = false
//                }else {
//                    sender.isSelected = true
//                }
//            }
//
//        }
//
          // sender.isSelected = !sender.isSelected
    }
}
