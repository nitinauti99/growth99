//
//  ConsentsTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 05/02/23.
//

import UIKit

class ConsentsTableViewCell: UITableViewCell {

    @IBOutlet private weak var questionnaireName: UILabel!
    @IBOutlet private weak var questionnaireID: UILabel!
    @IBOutlet private weak var questionnaireSelection: UIButton!
    @IBOutlet private weak var subView: UIView!

    var dateFormater : DateFormaterProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.questionnaireName?.text = nil
        self.questionnaireID?.text = nil
        self.questionnaireSelection.imageView?.image = nil
    }
    
    func configureCell(consentsVM: AddNewConsentsViewModelProtocol?, index: IndexPath) {
        let consentsVM = consentsVM?.ConsentsDataAtIndex(index: index.row)
        self.questionnaireName.text = consentsVM?.name
        self.questionnaireID.text = String(consentsVM?.id ?? 0)
    }
    
    @IBAction func selectionButtonPressed(sender: UIButton) {
        if sender.isSelected {
            sender.setBackgroundImage(#imageLiteral(resourceName: "tickselected"), for: .normal)
        } else {
            sender.setBackgroundImage(#imageLiteral(resourceName: "tickdefault"), for:.normal)
        }
        sender.isSelected = !sender.isSelected
    }
}
