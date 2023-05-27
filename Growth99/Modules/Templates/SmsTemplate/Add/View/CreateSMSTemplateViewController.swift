//
//  CreateSMSTemplateViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation
import UIKit

protocol CreateSMSTemplateViewControllerProtocol {
    func recivedMassSMSVariablesList()
    func recivedAppointmentVariablesList()
    func recivedLeadVariablesList()
    func recivedSMSTemplateData()
    func errorReceived(error: String)
    func smsTemplateCreatedSuccessfully()
}

class CreateSMSTemplateViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHight: NSLayoutConstraint!
    @IBOutlet weak var moduleTextField: CustomTextField!
    @IBOutlet weak var targetTextField: CustomTextField!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var bodyTextView: CustomTextView!
    @IBOutlet weak var showCharacterLBI: UILabel!

    @IBOutlet weak var isCustom: UISwitch!
    var count = 0

    var viewModel: CreateSMSTemplateViewModelProtocol?
    var selectedIndex = Int()
    var screenTitle: String = ""
    var smsTemplateId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateSMSTemplateViewModel(delegate: self)
        self.isCustom.setOn(false, animated: false)
        self.getSMSTemplate()
        self.targetTextField.placeholder = "Select Target"
        self.collectionView.register(UINib(nibName: "CreateSMSTemplateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CreateSMSTemplateCollectionViewCell")
        self.setVarableData(selectedSegmentIndex: selectedIndex)
    }
    
    func getSMSTemplate(){
        if self.screenTitle == "Edit" {
            self.title = Constant.Profile.editSMSTemplate
            self.view.ShowSpinner()
            self.viewModel?.getSMSTemplateData(smsTemplateId: smsTemplateId)
        }else{
            self.view.ShowSpinner()
            self.title = Constant.Profile.createSMSTemplate
            self.viewModel?.getMassSMSVariablesList()
        }
    }
    
    func setVarableData(selectedSegmentIndex: Int) {
        switch selectedSegmentIndex {
        case 0:
            self.moduleTextField.text = "Lead"
            self.collectionView.reloadData()
        case 1:
            self.moduleTextField.text = "Appointment"
            self.collectionView.reloadData()
        case 2:
            self.moduleTextField.text = "Mass SMS"
            self.collectionView.reloadData()
       default:
            break
        }
    }
    
    func setUPUI(){
        let item = viewModel?.getSMSTemplateListData
        self.moduleTextField.text = item?.templateFor
        self.targetTextField.text = item?.smsTarget
        self.isCustom.setOn(item?.active ?? false, animated: false)
        self.nameTextField.text = item?.name
        self.bodyTextView.text = item?.body
    }
    
    @IBAction func selectModuleAction(sender: UIButton){
        let moduleArray = ["Lead","Appointment", "Mass SMS"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: moduleArray, cellType: .subTitle) { (cell, module, indexPath) in
            cell.textLabel?.text = module
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            selectionMenu.dismissAutomatically = true
            self?.moduleTextField.text  = text
            self?.targetTextField.text = ""
            self?.targetTextField.placeholder = "Select Target"

            if text == "Lead" {
                self?.selectedIndex = 0
                self?.collectionView.reloadData()
            }else if(text == "Appointment"){
                self?.selectedIndex = 1
                self?.collectionView.reloadData()
            }else{
                self?.selectedIndex = 2
                self?.collectionView.reloadData()
            }
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(moduleArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectTargetAction(sender: UIButton){
        var moduleArray = [String]()
        
        if self.moduleTextField.text == "Lead" {
            moduleArray = ["Lead","Clinic"]
        }else if(self.moduleTextField.text == "Appointment"){
            moduleArray = ["Patient","Clinic"]
        }else{
            moduleArray = ["Lead","Patient"]
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: moduleArray, cellType: .subTitle) { (cell, module, indexPath) in
            cell.textLabel?.text = module
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            selectionMenu.dismissAutomatically = true
            self?.targetTextField.text  = text
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(moduleArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func switchIsChanged(sender: UISwitch) {
        if sender.isOn {
            self.isCustom.setOn(true, animated: false)
        } else {
            self.isCustom.setOn(false, animated: false)
        }
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(sender: UIButton) {
        
        guard let textField = moduleTextField.text, !textField.isEmpty else {
            moduleTextField.showError(message: "Please select module")
            return
        }
        
        guard let textField = targetTextField.text, !textField.isEmpty else {
            targetTextField.showError(message: "Please select target")
            return
        }
        
        guard let textField = nameTextField.text, !textField.isEmpty else {
            nameTextField.showError(message: "Name is required.")
            return
        }
        
        guard let textView = bodyTextView.text, !textView.isEmpty else {
            return
        }
        
        let param: [String: Any] = [
            "id": self.smsTemplateId,
            "name": self.nameTextField.text ?? "",
            "body": self.bodyTextView.text ?? "",
            "templateFor": (self.moduleTextField.text ?? "").removingWhitespaces(),
            "smsTemplateName": "",
            "isCustom": self.isCustom.isSelected,
            "smsTarget": self.targetTextField.text ?? ""
        ]
        
        if self.screenTitle == "Edit" {
            self.view.ShowSpinner()
            self.viewModel?.updateSMSTemplate(smsTemplatesId: smsTemplateId, parameters: param)
        }else{
            self.view.ShowSpinner()
            self.viewModel?.crateSMSTemplate(parameters: param)
        }
    }
    
}

extension CreateSMSTemplateViewController: CreateSMSTemplateViewControllerProtocol {
   
    func recivedSMSTemplateData(){
        self.setUPUI()
        self.viewModel?.getMassSMSVariablesList()
    }
    
    func recivedMassSMSVariablesList(){
        self.viewModel?.getAppointmentVariablesList()
    }
    
    func recivedAppointmentVariablesList(){
        self.viewModel?.getLeadVariablesList()
    }
    
    func recivedLeadVariablesList(){
        self.view.HideSpinner()
        self.collectionView.reloadData()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHight.constant = height*2 + 50
        self.view.setNeedsLayout()
    }
    
    func smsTemplateCreatedSuccessfully(){
        self.view.HideSpinner()
        if self.screenTitle == "Edit" {
            self.view.showToast(message: "SMS Template updated successfully.", color: UIColor().successMessageColor())
        } else {
            self.view.showToast(message: "SMS Template saved successfully.", color: UIColor().successMessageColor())
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension CreateSMSTemplateViewController: CreateSMSTemplateCollectionViewCellDelegate {
  
    func selectVariable(cell: CreateSMSTemplateCollectionViewCell, index: IndexPath) {
        var variable: String = ""
        if self.moduleTextField.text == "Lead" {
            variable = viewModel?.getLeadTemplateListData(index: index.row).variable ?? ""
        }else if(self.moduleTextField.text == "Appointment"){
            variable = viewModel?.getAppointmentTemplateListData(index: index.row).variable ?? ""
        }else{
            variable = viewModel?.getMassSMSTemplateListData(index: index.row).variable ?? ""
        }
        let str: String = " ${\(variable )} "
        self.bodyTextView.text += str
    }
}

extension CreateSMSTemplateViewController: UITextFieldDelegate {
   
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == nameTextField {
            guard let textField = nameTextField.text, !textField.isEmpty else {
                nameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
                return
            }
        }
    }
    
}

extension String {
    func removingWhitespaces() -> String {
            return components(separatedBy: .whitespaces).joined()
        }
}

extension CreateSMSTemplateViewController: UITextViewDelegate {
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        print(text)
//        let trimmedString = text.trimmingCharacters(in: .whitespaces)
//        if(trimmedString.count != 0){
//            count += 1
//            print(count)
//        }
//        return true
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if numberOfChars > 120 {
            return false
        }
        return false
    }
}
