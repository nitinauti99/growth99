//
//  CreateFormViewController.swift
//  Growth99
//
//  Created by nitin auti on 13/02/23.

import Foundation
import UIKit

protocol CreateFormViewControllerProtocol {
    func FormsDataRecived(message: String)
    func errorReceived(error: String)
}

class CreateFormViewController: UIViewController, CreateFormViewControllerProtocol {
    
    @IBOutlet weak var Make_Public: UIButton!
    @IBOutlet weak var Enable_ModernUI: UIButton!
    @IBOutlet weak var Show_title_Form: UIButton!
    @IBOutlet weak var Show_title_Fields: UIButton!
    @IBOutlet weak var is_Custom: UIButton!
    @IBOutlet weak var Make_lead_generationForm: UIButton!
    @IBOutlet weak var Show_Custom_Content_Virtual_ConsultationLead: UIButton!
    @IBOutlet weak var Show_Thank_page_URL_ContactForm: UIButton!
    @IBOutlet weak var ConfigureThank_page_message_contactForm: UIButton!

    @IBOutlet weak var Show_Thank_page_URL_ContactForm_TextView: CustomTextField!
    @IBOutlet weak var Show_Thank_page_URL_ContactForm_TextView_SepraterHight: NSLayoutConstraint!
    @IBOutlet weak var ConfigureThank_page_message_contactForm_TextView: CustomTextField!
    @IBOutlet weak var ConfigureThank_page_message_contactForm_TextView_SepraterHight: NSLayoutConstraint!
    @IBOutlet weak var backroundImageSelctionLBI: UILabel!
    @IBOutlet weak var backroundImageSelctionButton: UIButton!
    @IBOutlet weak var questionnaireName: CustomTextField!
    @IBOutlet weak var buttonText: CustomTextField!
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var CancelButton : UIButton!
    @IBOutlet private weak var subView: UIView!

    var viewModel: CreateFormViewModelProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.createForm
        self.viewModel = CreateFormViewModel(delegate: self)
        self.setUpUI()
    }
    
    private func setUpUI(){
        self.buttonText.text = "Submit"
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        submitButton.roundCorners(corners: [.allCorners], radius: 10)
        CancelButton.roundCorners(corners: [.allCorners], radius: 10)
        Show_Thank_page_URL_ContactForm_TextView.isHidden = true
        Show_Thank_page_URL_ContactForm_TextView_SepraterHight.constant = 20
        ConfigureThank_page_message_contactForm_TextView.isHidden = true
        ConfigureThank_page_message_contactForm_TextView_SepraterHight.constant = 15
        backroundImageSelctionButton.roundCorners(corners: [.allCorners], radius: 6)
        backroundImageSelctionButton.isHidden = true
        backroundImageSelctionButton.layer.borderWidth = 2
        backroundImageSelctionButton.layer.borderColor = UIColor(hexString: "#009EDE").cgColor
        backroundImageSelctionLBI.isHidden = true
    }
    
    func FormsDataRecived(message: String){
        self.view.HideSpinner()
        self.view.showToast(message: message, color: .black)
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    @IBAction func Make_Public(sender: UIButton){
        print("Make_Public")
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    @IBAction func Enable_ModernUI(sender: UIButton){
        print("Enable_ModernUI")
        if sender.isSelected {
            sender.isSelected = false
            backroundImageSelctionLBI.isHidden = true
            backroundImageSelctionButton.isHidden = true
        } else {
            sender.isSelected = true
            backroundImageSelctionLBI.isHidden = false
            backroundImageSelctionButton.isHidden = false
        }
    }
    
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
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
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
            Show_Thank_page_URL_ContactForm_TextView_SepraterHight.constant = 20
        } else {
            sender.isSelected = true
            Show_Thank_page_URL_ContactForm_TextView.isHidden = false
            Show_Thank_page_URL_ContactForm_TextView_SepraterHight.constant = 80
        }
    }
    
    @IBAction func ConfigureThank_page_message_contactForm(sender: UIButton){
        print("ConfigureThank_page_message_contactForm")
        if sender.isSelected {
            sender.isSelected = false
            ConfigureThank_page_message_contactForm_TextView.isHidden = true
            ConfigureThank_page_message_contactForm_TextView_SepraterHight.constant = 20
        } else {
            sender.isSelected = true
            ConfigureThank_page_message_contactForm_TextView.isHidden = false
            ConfigureThank_page_message_contactForm_TextView_SepraterHight.constant = 80
        }
    }
    
    @IBAction func cancelAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton){
        let createFormList: [String : Any] = [
            "name": self.questionnaireName.text ?? String.blank,
            "isPublic": self.Make_Public.isSelected,
            "enableModernUi": self.Enable_ModernUI.isSelected,
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
            "buttonBackgroundColor": "#357ffa",
            "buttonForegroundColor": "#357ffa",
            "titleColor": "inherit",
            "popupTitleColor": "inherit",
            "popupLabelColor": "inherit",
            "inputBoxShadowColor": "#357ffa",
            "activeSideColor": "#003b6f",
            "textForComposer": "",
            "emailTemplateId": "",
            "submitButtonText": "Submit",
            "showThankYouPageUrlLinkInVC": false,
            "showThankYouPageUrlLinkInLandingPage": false,
            "thankYouPageUrlVC": "",
            "thankYouPageUrlLandingPage": "",
            "configureThankYouMessageInLandingPage": false,
            "configureThankYouMessageInVC": false,
            "thankYouPageMessageLandingPage": "",
            "thankYouPageMessageVC": ""
        ]
        
        self.view.ShowSpinner()
        viewModel?.saveCreateForm(formData: createFormList)
    }
}
