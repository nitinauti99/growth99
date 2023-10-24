//
//  questionAnswersTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 30/12/22.
//

import UIKit

protocol questionAnswersTableViewCellDelegate: AnyObject {
    func editButtonPressed(cell: questionAnswersTableViewCell)
}

class questionAnswersTableViewCell: UITableViewCell {
    @IBOutlet weak var qutionNameLbi: UILabel!
    @IBOutlet weak var ansLbi: HyperLinkLabel!
    @IBOutlet weak var editButton: UIButton!

    weak var delegate: questionAnswersTableViewCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func cnfigureCell(viewModel: leadDetailViewProtocol?, index: IndexPath){
        let patientQuestionList = viewModel?.getQuestionnaireDetailList(index: index.row)
        self.editButton.isHidden = true
        self.qutionNameLbi.text = patientQuestionList?.questionName
        self.ansLbi.text = patientQuestionList?.answerText
        
        if patientQuestionList?.answerText == nil {
            self.ansLbi.text = "-"
        }
        if patientQuestionList?.questionName == "Email" {
            UserRepository.shared.primaryEmailId = patientQuestionList?.answerText
        }
        
        if patientQuestionList?.questionName == "First Name" || patientQuestionList?.questionName == "Last Name" || patientQuestionList?.questionName == "Email" || patientQuestionList?.questionName == "Phone Number" {
            self.editButton.isHidden = false
            let image = UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate)
            self.editButton.setImage(image, for: .normal)
            self.editButton.tintColor = UIColor.init(hexString: "009EDE")
        }
        
        if patientQuestionList?.questionType == "Yes_No" {
            if  patientQuestionList?.answerText == "false" {
                self.ansLbi.text = "No"
            }else{
                self.ansLbi.text = "Yes"
            }
        }
        
        if patientQuestionList?.questionName == "Symptoms" {
            var answertext = String()
            guard let symptomsDict = self.convertStringToDictionary(text: patientQuestionList?.answerText ?? "") else {
                return
            }
            for item in symptomsDict {
                let key = item.key
                let values  = item.value
                print(item)
                var valueString = String()
                for value in values {
                    valueString += value
                }
                answertext += "\(key) : \(valueString) ,"
            }
            self.ansLbi.text = answertext
        }
      
        
        if patientQuestionList?.questionType == "File" {
            self.ansLbi.hyperLink = patientQuestionList?.answerText ?? ""
            ansLbi.updateHyperLinkText { _ in
                if let url = URL(string: patientQuestionList?.answerText ?? ""), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
        
    }
    
    @IBAction func editButtonPressed(sender: UIButton) {
        self.delegate?.editButtonPressed(cell: self)
    }
    
    func convertStringToDictionary(text: String) -> [String: [String]]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: [String]]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
    
}
