//
//  ConsentsTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 05/02/23.
//

import UIKit

class ConsentsTableViewCell: UITableViewCell {

    @IBOutlet  weak var questionnaireName: UILabel!
    @IBOutlet  weak var questionnaireID: UILabel!
    @IBOutlet  weak var questionnaireSelection: UIButton!
    @IBOutlet  weak var subView: UIView!

    var dateFormater : DateFormaterProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.questionnaireName.text?.removeAll()
        self.questionnaireID.text?.removeAll()
        self.questionnaireSelection.imageView?.image = nil
    }
    
    func configureCellWithSearch(consentsVM: AddNewConsentsViewModelProtocol?, index: IndexPath) {
        let consentsVM = consentsVM?.getConsentsFilterDataAtIndex(index: index.row)
        self.questionnaireName.text = consentsVM?.name
        self.questionnaireID.text = String(consentsVM?.id ?? 0)
    }
    
    func configureCell(consentsVM: AddNewConsentsViewModelProtocol?, index: IndexPath) {
        let consentsVM = consentsVM?.getConsentsDataAtIndex(index: index.row)
        self.questionnaireName.text = consentsVM?.name
        self.questionnaireID.text = String(consentsVM?.id ?? 0)
    }
    
    @IBAction func selectionButtonPressed(sender: UIButton) {
        if sender.isSelected {
            sender.setBackgroundImage(#imageLiteral(resourceName: "tickdefault"), for: .normal)
        } else {
            sender.setBackgroundImage(#imageLiteral(resourceName: "tickselected"), for: .normal)
        }
        sender.isSelected = !sender.isSelected
    }
}
