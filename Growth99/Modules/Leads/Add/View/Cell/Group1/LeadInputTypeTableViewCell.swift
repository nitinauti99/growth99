//
//  InputTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 28/12/22.
//

import UIKit

class LeadInputTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var inputeTypeTextField: CustomTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(questionarieVM: CreateLeadViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.getLeadQuestionnaireListAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.questionName
    }
    
}
