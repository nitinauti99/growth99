//
//  CreateQuestionnaireTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 11/04/23.
//

import UIKit

protocol CreateQuestionnaireTableViewCellDelegate: AnyObject {
    func presnetImagePickerController(cell: CreateQuestionnaireTableViewCell, imagePicker: UIImagePickerController)
    func dismissImagePickerController(cell: CreateQuestionnaireTableViewCell)
    func saveFoemData(data: [String : Any])
    func popToView()
}

class CreateQuestionnaireTableViewCell: UITableViewCell{
   
    @IBOutlet weak var Make_Public: UIButton!
    @IBOutlet weak var Enable_ModernUI: UIButton!
    @IBOutlet weak var Show_title_Form: UIButton!
    @IBOutlet weak var Show_title_Fields: UIButton!
    @IBOutlet weak var is_Custom: UIButton!
    @IBOutlet weak var Make_lead_generationForm: UIButton!
    @IBOutlet weak var Show_Custom_Content_Virtual_ConsultationLead: UIButton!
   
    @IBOutlet weak var Show_Thank_page_URL_ContactForm: UIButton!
    @IBOutlet weak var Show_Thank_page_URL_ContactForm_TextView: CustomTextField!
    @IBOutlet weak var Show_Thank_page_URL_ContactForm_TextView_Hight: NSLayoutConstraint!

    @IBOutlet weak var ConfigureThank_page_message_contactForm: UIButton!
    @IBOutlet weak var ConfigureThank_page_message_contactForm_TextView: CustomTextField!
    @IBOutlet weak var ConfigureThank_page_message_contactForm_TextView_Hight: NSLayoutConstraint!
  
//    @IBOutlet weak var backroundImageSelctionView: UIView!
//    @IBOutlet weak var backroundImageSelctionViewHight: NSLayoutConstraint!
//    @IBOutlet weak var backroundImageSelctionLBI: UILabel!
//    @IBOutlet weak var backroundImageSelctionButton: UIButton!
//    @IBOutlet weak var backroundImage: UIImageView!
//    @IBOutlet weak var backroundImageHight: NSLayoutConstraint!

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    @IBOutlet weak var questionnaireName: CustomTextField!
    @IBOutlet weak var buttonText: CustomTextField!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var subView: UIView!

    var delegate: CreateQuestionnaireTableViewCellDelegate?
    var viewModel: FormDetailViewModelProtocol?

    var tableView: UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        self.setUpUI()
    }

    func configureCell(tableView: UITableView?, viewModel: FormDetailViewModelProtocol?, index: IndexPath) {
        self.viewModel = viewModel
        self.setUPVale()
        self.tableView = tableView
    }
    
    private func setUpUI(){
        self.Show_Thank_page_URL_ContactForm_TextView.isHidden = true
        self.ConfigureThank_page_message_contactForm_TextView.isHidden = true
//        self.backroundImageSelctionViewHight.constant = 0
//        backroundImageSelctionLBI.isHidden = true
//        backroundImageSelctionButton.isHidden = true
    }
    
   public func setUPVale() {
        let item =  self.viewModel?.getFormQuestionnaireData
        
       self.questionnaireName.text = item?.name
        self.Make_Public.isSelected = item?.isPublic ?? false
        self.Show_title_Form.isSelected = item?.showTitle ?? false
        self.Show_title_Fields.isSelected = item?.hideFieldTitle ?? false // need to check
        self.is_Custom.isSelected = item?.isCustom ?? false
        self.buttonText.text = item?.submitButtonText ?? ""
        self.Make_lead_generationForm.isSelected = item?.isLeadForm ?? false
        self.Show_Custom_Content_Virtual_ConsultationLead.isSelected = item?.showTextForComposer ?? false
        self.Show_Thank_page_URL_ContactForm.isSelected = item?.showThankYouPageUrlLinkInContactForm ?? false
        
        self.ConfigureThank_page_message_contactForm.isSelected = item?.configureThankYouMessageInContactForm ?? false
        
        if item?.showThankYouPageUrlLinkInContactForm  == true {
            Show_Thank_page_URL_ContactForm_TextView_Hight.constant = 45
            Show_Thank_page_URL_ContactForm_TextView.isHidden = false
            Show_Thank_page_URL_ContactForm_TextView.text = item?.thankYouPageUrl ?? String.blank
        }
        if item?.configureThankYouMessageInContactForm  == true {
            ConfigureThank_page_message_contactForm_TextView_Hight.constant = 45
            ConfigureThank_page_message_contactForm_TextView.isHidden = false
            ConfigureThank_page_message_contactForm_TextView.text = item?.thankYouPageMessageContactForm ?? ""
        }
        
     
    }
    
    @IBAction func Make_Public(sender: UIButton){
        print("Make_Public")
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
//    @IBAction func Enable_ModernUI(sender: UIButton){
//        print("Enable_ModernUI")
//        if sender.isSelected {
//            sender.isSelected = false
//            backroundImageSelctionView.isHidden = true
//            backroundImageSelctionViewHight.constant = 0
//            backroundImageSelctionLBI.isHidden = true
//            backroundImageSelctionButton.isHidden = true
//        } else {
//            sender.isSelected = true
//            backroundImageSelctionView.isHidden = false
//            backroundImageSelctionViewHight.constant = 220
//            backroundImageSelctionLBI.isHidden = false
//            backroundImageSelctionButton.isHidden = false
//            self.tableView?.performBatchUpdates(nil, completion: nil)
//        }
//    }
    
    @IBAction func Show_title_Form(sender: UIButton){
        print("Show_title_Form")
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func Show_title_Fields(sender: UIButton){
        print("Show_title_Fields")
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func is_Custom(sender: UIButton){
        print("is_Custom")
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func Make_lead_generationForm(sender: UIButton){
        print("Make_lead_generationForm")
        let item =  self.viewModel?.getFormQuestionnaireData

        if item?.isLeadForm == true {
            sender.isSelected = true
        }else{
            if sender.isSelected {
                sender.isSelected = false
            } else {
                sender.isSelected = true
            }
        }
    }
    
    @IBAction func Show_Custom_Content_Virtual_ConsultationLead(sender: UIButton){
        print("Show_Custom_Content_Virtual_ConsultationLead")
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func Show_Thank_page_URL_ContactForm(sender: UIButton){
        print("Show_Thank_page_URL_ContactForm")
        if sender.isSelected {
            sender.isSelected = false
            Show_Thank_page_URL_ContactForm_TextView.isHidden = true
            Show_Thank_page_URL_ContactForm_TextView_Hight.constant = 0
        } else {
            sender.isSelected = true
            Show_Thank_page_URL_ContactForm_TextView.isHidden = false
            Show_Thank_page_URL_ContactForm_TextView_Hight.constant = 45
            self.tableView?.performBatchUpdates(nil, completion: nil)
        }
    }
    
    @IBAction func ConfigureThank_page_message_contactForm(sender: UIButton){
        print("ConfigureThank_page_message_contactForm")
        if sender.isSelected {
            sender.isSelected = false
            ConfigureThank_page_message_contactForm_TextView.isHidden = true
            ConfigureThank_page_message_contactForm_TextView_Hight.constant = 0
        } else {
            sender.isSelected = true
            ConfigureThank_page_message_contactForm_TextView.isHidden = false
            ConfigureThank_page_message_contactForm_TextView_Hight.constant = 45
            self.tableView?.performBatchUpdates(nil, completion: nil)
        }
    }
}


extension CreateQuestionnaireTableViewCell {
  
    @IBAction func cancelAction(sender: UIButton){
        delegate?.popToView()
    }
    @IBAction func saveAction(sender: UIButton){
        guard let questionnaire  = questionnaireName.text, !questionnaire.isEmpty else {
            questionnaireName.showError(message: "Questionnaire Name is required")
                return
        }
        
        let createFormList: [String : Any] = [
            
            "name": self.questionnaireName.text ?? String.blank,
            "isPublic": self.Make_Public.isSelected,
            "showTitle": self.Show_title_Form.isSelected,
            "hideFieldTitle": self.Show_title_Fields.isSelected,
            "isCustom": self.is_Custom.isSelected,
            "isLeadForm": self.Make_lead_generationForm.isSelected,
            "showTextForComposer": self.Show_Custom_Content_Virtual_ConsultationLead.isSelected,
            "showThankYouPageUrlLinkInContactForm": self.Show_Thank_page_URL_ContactForm.isSelected,
            "thankYouPageUrl": Show_Thank_page_URL_ContactForm_TextView.text ?? String.blank,
            "configureThankYouMessageInContactForm": ConfigureThank_page_message_contactForm.isSelected,
            "thankYouPageMessageContactForm": ConfigureThank_page_message_contactForm_TextView.text ?? String.blank,
            
            "chatQuestionnaire": false,
            "buttonBackgroundColor": viewModel?.getThemeColorData?.buttonBackgroundColor ?? "",
            "buttonForegroundColor": viewModel?.getThemeColorData?.buttonForegroundColor ?? "",
            "titleColor": viewModel?.getThemeColorData?.titleColor ?? "",
            "textForComposer": "",
            "emailTemplateId": "",
            "submitButtonText": self.buttonText.text ?? "",
            "showThankYouPageUrlLinkInVC": false,
            "showThankYouPageUrlLinkInLandingPage": false,
            "thankYouPageUrlVC": "",
            "thankYouPageUrlLandingPage": "",
            "configureThankYouMessageInLandingPage": false,
            "configureThankYouMessageInVC": false,
            "thankYouPageMessageLandingPage": "",
            "thankYouPageMessageVC": ""
        ]
        
        delegate?.saveFoemData(data: createFormList)
    }
    
}
