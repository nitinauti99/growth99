//
//  FormDetailTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 16/02/23.
//

import UIKit

class FormDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionNameTextfield: CustomTextField!
    @IBOutlet weak var requiredButton: UIButton!
    @IBOutlet weak var hiddenButton: UIButton!
    @IBOutlet weak var validateButton: UIButton!

    @IBOutlet weak var regexTextfield: CustomTextField!
    @IBOutlet weak var validationMessageTextfield: CustomTextField!
    
    @IBOutlet weak var backroundImageSelctionLBI: UILabel!
    @IBOutlet weak var inputBoxButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var yesNoButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var multipleSelectionButton: UIButton!
    @IBOutlet weak var fileButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var validationView: UIView!
    @IBOutlet weak var multipleSelectionView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var subViewHight: NSLayoutConstraint!
    @IBOutlet weak var multipleSelectionViewHight: NSLayoutConstraint!
    @IBOutlet weak var validationViewHight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        self.dissableUserIntraction()
        self.bottomView.isHidden = true
        self.subViewHight.constant = 0
    }

    func configureCell(FormList: FormDetailViewModelProtocol?, index: IndexPath) {
        self.setUPUI(FormList, index)
        self.saveButton.roundCorners(corners: [.allCorners], radius: 25)
        self.cancelButton.roundCorners(corners: [.allCorners], radius: 25)
    }
    
    fileprivate func setUPUI(_ FormList: FormDetailViewModelProtocol?, _ index: IndexPath) {
        let FormList = FormList?.FormDataAtIndex(index: index.row)
        self.questionNameTextfield.text = FormList?.name
        self.requiredButton.isSelected = FormList?.required ?? false
        self.hiddenButton.isSelected = FormList?.hidden ?? false
        self.validateButton.isSelected = FormList?.validate ?? false
        self.validationViewHight.constant = 0
        self.validationView.isHidden = true
        self.multipleSelectionView.isHidden = true
        self.multipleSelectionViewHight.constant = 0
        if FormList?.validate == true {
            self.validationViewHight.constant = 180
            self.validationView.isHidden = false
        }
        self.validationMessageTextfield.text = FormList?.validationMessage
        self.selctionType(selctionType:FormList?.type ?? "")
    }
    
    func dissableUserIntraction() {
        self.questionNameTextfield.isUserInteractionEnabled = false
        self.requiredButton.isUserInteractionEnabled = false
        self.hiddenButton.isUserInteractionEnabled = false
        self.validateButton.isUserInteractionEnabled = false
        self.validationMessageTextfield.isUserInteractionEnabled = false
        self.questionNameTextfield.isUserInteractionEnabled = false
        self.inputBoxButton.isUserInteractionEnabled = false
        self.textButton.isUserInteractionEnabled = false
        self.yesNoButton.isUserInteractionEnabled = false
        self.dateButton.isUserInteractionEnabled = false
        self.multipleSelectionButton.isUserInteractionEnabled = false
        self.fileButton.isUserInteractionEnabled = false
        self.regexTextfield.isUserInteractionEnabled = false
    }
    
    func selctionType(selctionType: String){
        switch selctionType {
        case  "Input":
            self.inputBoxButton.isSelected = true
        case "Text":
            self.textButton.isSelected = true
        case "Yes_No":
            self.yesNoButton.isSelected = true
        case  "Date":
            self.dateButton.isSelected = true
        case "Multiple_Selection_Text":
            self.multipleSelectionButton.isSelected = true
        case "File":
            self.fileButton.isSelected = true
        default:
            break
        }
    }
    
    /// edit button pressed
    
    @IBAction func editButtonAction(sender: UIButton) {
        self.bottomView.isHidden = false
        self.subViewHight.constant = 76
    }
       
}
