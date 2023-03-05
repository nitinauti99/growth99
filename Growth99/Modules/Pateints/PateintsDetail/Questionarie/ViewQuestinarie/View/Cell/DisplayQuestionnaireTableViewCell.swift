//
//  DisplayQuestionariTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 01/03/23.
//

import UIKit

class DisplayQuestionnaireTableViewCell: UITableViewCell {
    @IBOutlet private weak var questionName: UILabel!
    @IBOutlet private weak var questionAns: UILabel!
    @IBOutlet private weak var subView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }

    func configureCell(questionnaireVM: DisplayQuestionnaireViewModelProtocol?, index: IndexPath) {
        let questionnaireVM = questionnaireVM?.getQuestionnaireDataAtIndex(index: index.row)
        self.questionName.text = questionnaireVM?.questionName
        self.questionAns.text = questionnaireVM?.answerText
        var selectedStringArray = [String]()
        if questionnaireVM?.questionType == "Multiple_Selection_Text" {
            for item in questionnaireVM?.patientQuestionChoices ?? [] {
                selectedStringArray.append(item.choiceName ?? String.blank)
            }
            self.questionAns.text = selectedStringArray.joined(separator: ",")
        }
    }
    
}
