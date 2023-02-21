//
//  FormQuestionTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 19/02/23.
//

import UIKit

protocol FormQuestionTableViewCellDelegate: AnyObject {
    func deletRowFormCell(cell: FormQuestionTableViewCell, index: IndexPath)
}

class FormQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionNameTextfield: CustomTextField!
    weak var delegate: FormQuestionTableViewCellDelegate?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(tableView: UITableView?, FormList: QuestionsList?, index: IndexPath) {
        self.questionNameTextfield.text = FormList?.questionName
        self.indexPath = index
    }
    
    @IBAction func deletRow(sender: UIButton) {
        delegate?.deletRowFormCell(cell: self, index: indexPath)
    }
}
