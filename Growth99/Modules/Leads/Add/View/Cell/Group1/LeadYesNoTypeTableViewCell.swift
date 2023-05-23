//
//  YesNoTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 28/12/22.
//

import UIKit

class LeadYesNoTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var yesTypeButton: UIButton!
    @IBOutlet weak var NoTypeButton: UIButton!
    @IBOutlet weak var asteriskSign: UILabel!

    var buttons = [UIButton]()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttons.append(yesTypeButton)
        self.buttons.append(NoTypeButton)
        self.yesTypeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.NoTypeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    func configureCell(questionarieVM: CreateLeadViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.getLeadQuestionnaireListAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.questionName
        self.asteriskSign.isHidden = true
        if questionarieVM?.required == true {
            self.asteriskSign.isHidden = false
        }
    }
    
    @objc func buttonAction(sender: UIButton!){
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
    }
}
