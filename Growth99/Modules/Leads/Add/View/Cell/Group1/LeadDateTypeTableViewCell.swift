//
//  DateTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 29/12/22.
//

import UIKit

class LeadDateTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var dateTypeTextField: CustomTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(questionarieVM: CreateLeadViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.getLeadQuestionnaireListAtIndex(index: index.row)
        self.questionnaireName.text = questionarieVM?.questionName
        self.dateTypeTextField.addInputViewDatePicker(target: self,
                                                 selector: #selector(dateFromButtonPressed),
                                                 mode: .date)
    }
    
    @objc func dateFromButtonPressed() {
        dateTypeTextField.text = dateFormatterString(textField: dateTypeTextField)
    }

    func dateFormatterString(textField: CustomTextField) -> String {
        var datePicker = UIDatePicker()
        datePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let todaysDate = Date()
        datePicker.minimumDate = todaysDate
        textField.resignFirstResponder()
        datePicker.reloadInputViews()
        return dateFormatter.string(from: datePicker.date)
    }
}
