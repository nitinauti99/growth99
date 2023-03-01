//
//  QuestionarieTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 21/01/23.
//

import UIKit

class QuestionarieTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var questionnaireName: UILabel!
    @IBOutlet private weak var appointmentID: UILabel!
    @IBOutlet private weak var questionnaireStatus: UILabel!
    @IBOutlet private weak var submittedDate: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var subView: UIView!

    var dateFormater : DateFormaterProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }
    
    func configureCell(questionarieVM: QuestionarieViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.getQuestionarieDataAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.questionnaireName
        self.appointmentID.text = questionarieVM?.AppointmentId
        self.questionnaireStatus.text = questionarieVM?.questionnaireStatus
        self.submittedDate.text = dateFormater?.serverToLocal(date: questionarieVM?.submittedDate ?? String.blank)
        self.createdDate.text = dateFormater?.serverToLocal(date: questionarieVM?.createdAt ?? String.blank)
    }
    
    func configureCellWithSearch(questionarieVM: QuestionarieViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.getQuestionarieFilterDataAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.questionnaireName
        self.appointmentID.text = questionarieVM?.AppointmentId
        self.questionnaireStatus.text = questionarieVM?.questionnaireStatus
        self.submittedDate.text = questionarieVM?.submittedDate
        self.createdDate.text = dateFormater?.serverToLocal(date: questionarieVM?.createdAt ?? String.blank)
    }
}
