//
//  TextTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 28/12/22.
//

import UIKit

class TextTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var textTypeTextField: UITextView!
    @IBOutlet weak var errorTypeLbi: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textTypeTextField.layer.borderColor = UIColor.gray.cgColor;
        textTypeTextField.layer.borderWidth = 1.0;
    }

    func configureCell(questionarieVM: FillQuestionarieViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.getQuestionnaireListAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.questionName
    }
    
}
