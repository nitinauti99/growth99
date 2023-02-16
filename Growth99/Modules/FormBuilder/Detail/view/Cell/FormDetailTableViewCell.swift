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
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var validationView: UIView!
    @IBOutlet weak var multipleSelectionView: UIView!
   
    @IBOutlet weak var validationViewHight: NSLayoutConstraint!

        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
    }

    func configureCell(FormList: FormDetailViewModelProtocol?, index: IndexPath) {
        let FormList = FormList?.FormDataAtIndex(index: index.row)
        self.questionNameTextfield.text = FormList?.name
        requiredButton.isSelected = FormList?.required ?? false
        hiddenButton.isSelected = FormList?.hidden ?? false
        validateButton.isSelected = FormList?.validate ?? false
        validationViewHight.constant = 0
        validationView.isHidden = true

        if FormList?.validate == true {
            validationViewHight.constant = 180
            validationView.isHidden = false
        }
//        indexPath = index
    }
    
}
