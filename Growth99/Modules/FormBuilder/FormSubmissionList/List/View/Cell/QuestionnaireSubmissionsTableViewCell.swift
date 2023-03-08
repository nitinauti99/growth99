//
//  QuestionnaireSubmissionsTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 08/03/23.
//

import UIKit

class QuestionnaireSubmissionsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var updatedDate: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var statusButton: UIButton!
    @IBOutlet private weak var subView: UIView!

    var dateFormater : DateFormaterProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }
    
    func configureCell(questionarieVM: QuestionnaireSubmissionsViewModelModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.getQuestionarieDataAtIndex(index: index.row)
        self.id.text = String(questionarieVM?.id ?? 0)
        self.updatedDate.text = dateFormater?.serverToLocal(date: questionarieVM?.updatedAt ?? String.blank)
        self.createdDate.text = dateFormater?.serverToLocal(date: questionarieVM?.createdAt ?? String.blank)
    }
    
}
