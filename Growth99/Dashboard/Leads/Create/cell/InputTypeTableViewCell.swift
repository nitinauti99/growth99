//
//  InputTypeTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 17/12/22.
//

import UIKit

class InputTypeTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var inputTextField: CustomTextField!
    @IBOutlet weak var inputText: UILabel!
  
    var leadVM: PatientQuestionAnswersList?
    var tagNumber : Int = 0
    var tableview : UITableView?
    private var viewModel: CreateLeadViewModelProtocol?
    var leadUserQuestionnairefinalList =  [PatientQuestionAnswersList]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(leadVM: CreateLeadViewModelProtocol?, index: IndexPath, tableview: UITableView) {
        self.viewModel = leadVM
        self.leadVM = leadVM?.leadUserQuestionnaireListAtIndex(index: index.row)
        self.tableview = tableview
        inputText.text = self.leadVM?.questionName
        self.inputTextField.tag = index.row
    }

//    func textFieldDidChange(_ textField: UITextField) {
//        let leadVM = self.viewModel?.leadUserQuestionnaireListAtIndex(index: textField.tag)
//
//        if textField.text == "", !self.isValidTextFieldData(textField.text ?? "", regex: leadVM?.regex ?? "") {
//            inputTextField.showError(message: leadVM?.validationMessage)
//            self.leadUserQuestionnairefinalList.insert(leadVM!, at: textField.tag)
//        }
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var leadVM = self.viewModel?.leadUserQuestionnaireListAtIndex(index: textField.tag)
        if textField.text == "", !self.isValidTextFieldData(textField.text ?? "", regex: leadVM?.regex ?? "") {
            inputTextField.showError(message: leadVM?.validationMessage)
        }else{
//            leadVM?.answerText = textField.text
//            leadUserQuestionnairefinalList.insert(leadVM!, at: textField.tag)
//            print(leadUserQuestionnairefinalList)
        } 
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let leadVM = self.viewModel?.leadUserQuestionnaireListAtIndex(index: textField.tag)
       
        if textField.text == "", !self.isValidTextFieldData(textField.text ?? "", regex: leadVM?.regex ?? "") {
            inputTextField.showError(message: leadVM?.validationMessage)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var leadVM = self.viewModel?.leadUserQuestionnaireListAtIndex(index: textField.tag)
        leadVM?.answerText = textField.text
       
    }
}
extension UIResponder {
    func next<T:UIResponder>(ofType: T.Type) -> T? {
        let r = self.next
        if let r = r as? T ?? r?.next(ofType: T.self) {
            return r
        } else {
            return nil
        }
    }
}

extension InputTypeTableViewCell {
    func isValidTextFieldData(_ textField: String, regex: String) -> Bool {
        let textFieldValidation = NSPredicate(format:"SELF MATCHES %@", regex)
        return textFieldValidation.evaluate(with: textField)
    }
}

//        if let cell = textField.next(ofType: InputTypeTableViewCell.self) {
//            if let ip = self.tableview?.indexPath(for:cell) {
//               // whatever
//                print(ip.row)
//            }
//        }
