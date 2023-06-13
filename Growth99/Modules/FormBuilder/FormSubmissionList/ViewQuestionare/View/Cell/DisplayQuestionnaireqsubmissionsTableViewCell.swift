//
//  DisplayQuestionnaireqsubmissionsTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 08/03/23.
//

import UIKit

class DisplayQuestionnaireqsubmissionsTableViewCell: UITableViewCell {
    @IBOutlet private weak var questionName: UILabel!
    @IBOutlet private weak var questionAns: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCell(questionnaireVM: DisplayQuestionnaireqsubmissionsViewModelProtocol?, index: IndexPath) {
        let questionnaireVM = questionnaireVM?.getQuestionnaireDataAtIndex(index: index.row)
        self.questionName.text = questionnaireVM?.questionName
        self.questionAns.text = questionnaireVM?.answerText
        
        if questionnaireVM?.questionType == "Yes_No" {
            if let ans = questionnaireVM?.answerText, ans == "false" {
                self.questionAns.text = "no"
            }else{
                self.questionAns.text = "yes"
            }
        }
    }
    
}
