//
//  FormDetailViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 15/02/23.
//

import Foundation
import UIKit

protocol FormDetailViewControllerProtocol {
    func FormsDataRecived()
    func errorReceived(error: String)
    func formsQuestionareDataRecived()
    func updatedFormDataSuccessfully()
    func questionRemovedSuccefully(mrssage: String)
}
class FormDetailViewController: UIViewController, FormDetailViewControllerProtocol, FormDetailTableViewCellDelegate {
   
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
    @IBOutlet weak var backroundImage: UIImageView!
    @IBOutlet weak var questionnaireName: CustomTextField!
    @IBOutlet weak var buttonText: CustomTextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet private weak var subView: UIView!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var workingScrollViewHight: NSLayoutConstraint!

    @IBOutlet weak var addQuestionButton: UIButton!

    var viewModel: FormDetailViewModelProtocol?
    var questionId = Int()
    var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FormDetailViewModel(delegate: self)
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        self.scrollView.delegate = self
        self.setUpUI()
        self.view.ShowSpinner()
        viewModel?.getFormQuestionnaireData(questionnaireId: questionId)
        tableView.register(UINib(nibName: "FormDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "FormDetailTableViewCell")
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
        addQuestionButton.layer.borderWidth = 2
        addQuestionButton.roundCorners(corners: [.allCorners], radius: 5)
        addQuestionButton.layer.borderColor = UIColor(hexString: "#009EDE").cgColor
        backroundImageSelctionLBI.isHidden = true
    }
    
    func FormsDataRecived(message: String){
        self.view.HideSpinner()
        self.view.showToast(message: message, color: .black)
        self.navigationController?.popViewController(animated: true)
    }
    
    func reloadForm(cell: FormDetailTableViewCell, index: IndexPath){
        tableView.beginUpdates()
        self.tableView.reloadRows(at: [index], with: UITableView.RowAnimation.none)
        tableView.endUpdates()
    }

    func FormsDataRecived() {
        self.view.HideSpinner()
        tableView.reloadData()
    }
    
    func updatedFormDataSuccessfully(){
        self.view.showToast(message: "Form Data Updated Successfully", color: .black)
        self.navigationController?.popViewController(animated: true)
    }

    func formsQuestionareDataRecived(){
        self.setUPVale()
        viewModel?.getFormDetail(questionId: questionId)
    }

    func setUPVale() {
        let item = viewModel?.getFormQuestionnaireData
        self.questionnaireName.text = item?.name
        self.Make_Public.isSelected = item?.isPublic ?? false
        self.Enable_ModernUI.isSelected = item?.enableModernUi ?? false
        self.Show_title_Form.isSelected = item?.showTitle ?? false
        self.Show_title_Fields.isSelected = item?.hideFieldTitle ?? false // need to check
        self.is_Custom.isSelected = item?.isCustom ?? false
        self.Make_lead_generationForm.isSelected = item?.isLeadForm ?? false
        self.Show_Custom_Content_Virtual_ConsultationLead.isSelected = item?.showTextForComposer ?? false
        self.Show_Thank_page_URL_ContactForm.isSelected = item?.showThankYouPageUrlLinkInContactForm ?? false
        
        self.ConfigureThank_page_message_contactForm.isSelected = item?.configureThankYouMessageInContactForm ?? false
        
        if item?.showThankYouPageUrlLinkInContactForm  == true {
            Show_Thank_page_URL_ContactForm_TextView_SepraterHight.constant = 80
            Show_Thank_page_URL_ContactForm_TextView.isHidden = false
            Show_Thank_page_URL_ContactForm_TextView.text = item?.thankYouPageUrl ?? String.blank
        }
        if item?.configureThankYouMessageInContactForm  == true {
            ConfigureThank_page_message_contactForm_TextView_SepraterHight.constant = 80
            ConfigureThank_page_message_contactForm_TextView.isHidden = false
            ConfigureThank_page_message_contactForm_TextView.text = item?.thankYouPageMessageContactForm ?? ""
        }
        
        if item?.enableModernUi ?? false == true {
            backroundImageSelctionLBI.isHidden = false
            backroundImageSelctionButton.isHidden = false
        }
    }
    
    func showRegexList(cell: FormDetailTableViewCell, sender: UIButton, index: IndexPath){
       
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: RegexList().regexArray, cellType: .subTitle) { (cell, list, indexPath) in
            cell.textLabel?.text = list
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.regexTextfield.text = ""
            cell.regexTextfield.text = selectedItem
            selectionMenu.dismissAutomatically = true
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(RegexList().regexArray.count * 44))), arrowDirection: .up), from: self)
    }

    
    func scrollViewHeight() {
        workingScrollViewHight.constant = tableViewHeight + 1000 + 350
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
    
    func deleteNotSsavedQuestion(cell: FormDetailTableViewCell, index: IndexPath) {
        viewModel?.removeFormData(index: index)
        self.tableView.deleteRows(at: [index], with: .automatic)
        self.tableView?.performBatchUpdates(nil, completion: nil)
        self.tableView.reloadData()
        self.scrollViewHeight()
    }
    
    @IBAction func addQuestionAction(sender:UIButton) {
        let createdBy = CreatedBy(firstName: "", lastName: "", email: "", username: "")
        let updatedBy =  UpdatedBy(firstName: "", lastName: "", email: "", username: "")

        let formItem  = FormDetailModel(createdAt: "", updatedAt: "", createdBy: createdBy, updatedBy: updatedBy, deleted: false, tenantId: 0, id: 0, name: "", type: "", answer: "", required: false, questionOrder:0, allowMultipleSelection: false, allowLabelsDisplayWithImages: false, hidden: false, validate: false, regex: "", validationMessage: "", showDropDown: false, preSelectCheckbox: false, description: "", subHeading: "", questionChoices: [], questionImages: [])
        
        viewModel?.addFormDetailData(item: formItem)
        NotificationCenter.default.post(name: Notification.Name("notificationCreateQuestion"), object: nil)
        let indexPath = IndexPath(row: (viewModel?.getFormDetailData.count ?? 0) - 1 , section: 0)
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.reloadData()
    }
    
    @IBAction func cancelAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteQuestion(name: String, id: Int){
        let alert = UIAlertController(title: Constant.Profile.deleteConcents , message: "Are you sure you want to delete \n\(name)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                        handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeQuestions(questionId: self?.questionId ?? 0, childQuestionId: id )

        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func questionRemovedSuccefully(mrssage: String) {
        self.view.showToast(message: mrssage, color: .red)
        viewModel?.getFormQuestionnaireData(questionnaireId: questionId)
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
        viewModel?.updateFormData(questionnaireId: questionId,formData: createFormList)
    }
    
    func saveFormData(item: [String : Any]) {
        self.view.ShowSpinner()
        viewModel?.updateQuestionFormData(questionnaireId: self.questionId, formData: item)
    }
}

extension FormDetailViewController: UIScrollViewDelegate {
    
   internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
        scrollViewHeight()
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
    
}
