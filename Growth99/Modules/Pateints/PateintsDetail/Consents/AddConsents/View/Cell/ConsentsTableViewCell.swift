//
//  ConsentsTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 05/02/23.
//

import UIKit

protocol ConsentsTableViewCellDelegate: AnyObject {
    func checkButtonClick(cell: ConsentsTableViewCell, index: IndexPath)
}

class ConsentsTableViewCell: UITableViewCell {

    @IBOutlet  weak var questionnaireName: UILabel!
    @IBOutlet  weak var questionnaireID: UILabel!
    @IBOutlet  weak var questionnaireSelection: UIButton!
    @IBOutlet  weak var subView: UIView!

    var dateFormater : DateFormaterProtocol?
    var userSelectedRows: [IndexPath] = []
    var userSelectedIndexPath = IndexPath()
    
    weak var delegate: ConsentsTableViewCellDelegate?

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
    
    func configureCellWithSearch(consentsVM: AddNewConsentsViewModelProtocol?, index: IndexPath, selectedRows: [IndexPath]) {
        let consentsVM = consentsVM?.getConsentsFilterDataAtIndex(index: index.row)
        self.questionnaireName.text = consentsVM?.name
        self.questionnaireID.text = String(consentsVM?.id ?? 0)
        self.userSelectedRows = selectedRows
        self.userSelectedIndexPath = index
        if self.userSelectedRows.contains(index) {
            questionnaireSelection.setImage(UIImage(named:"tickdefault"), for: .normal)
            questionnaireSelection.isSelected = false
        } else {
            questionnaireSelection.setImage(UIImage(named:"tickselected"), for: .normal)
            questionnaireSelection.isSelected = true
        }
        questionnaireSelection.tag = index.row
    }
    
    func configureCell(consentsVM: AddNewConsentsViewModelProtocol?, index: IndexPath, selectedRows: [IndexPath]) {
        let consentsVM = consentsVM?.getConsentsDataAtIndex(index: index.row)
        self.questionnaireName.text = consentsVM?.name
        self.questionnaireID.text = String(consentsVM?.id ?? 0)
        self.userSelectedRows = selectedRows
        self.userSelectedIndexPath = index
        if self.userSelectedRows.contains(index) {
            questionnaireSelection.setImage(UIImage(named:"tickselected"), for: .normal)
            questionnaireSelection.isSelected = true
        } else {
            questionnaireSelection.setImage(UIImage(named:"tickdefault"), for: .normal)
            questionnaireSelection.isSelected = false
        }
        questionnaireSelection.tag = index.row
    }
    
    @IBAction func selectionButtonPressed(sender: UIButton) {
        self.delegate?.checkButtonClick(cell: self, index: userSelectedIndexPath)
    }
}
