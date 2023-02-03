//
//  PateintsTagListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 29/01/23.
//

import UIKit

protocol PateintsTagListTableViewCellDelegate: AnyObject {
    func removePatieint(cell: PateintsTagListTableViewCell, index: IndexPath)
    func editPatieint(cell: PateintsTagListTableViewCell, index: IndexPath)
    func detailPatieint(cell: PateintsTagListTableViewCell, index: IndexPath)
}

class PateintsTagListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var questionnaireName: UILabel!
    @IBOutlet private weak var questionnaireID: UILabel!
    @IBOutlet private weak var questionnaireSelection: UIButton!
    @IBOutlet weak var subView: UIView!
    
    var dateFormater : DateFormaterProtocol?
    weak var delegate: PateintsTagListTableViewCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormater = DateFormater()
    }
    
    func configureCell(questionarieVM: PateintsTagsListViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.QuestionarieDataAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.name
        self.questionnaireID.text = String(questionarieVM?.id ?? 0)
        indexPath = index
    }
    
//    @IBAction func selectionButtonPressed() {
//       // self.delegate?.isQuestionnaireSelection(cell: self, index: indexPath)
//    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removePatieint(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editPatieint(cell: self, index: indexPath)
    }
    
    @IBAction func detailButtonPressed() {
        self.delegate?.detailPatieint(cell: self, index: indexPath)
    }
}
