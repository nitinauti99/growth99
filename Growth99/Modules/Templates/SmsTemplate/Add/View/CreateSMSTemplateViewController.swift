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
    
    @IBOutlet weak var isCustom: UISwitch!
    
    var viewModel: CreateSMSTemplateViewModelProtocol?
    var selectedIndex = Int()
    var screenTitle: String = ""
    var smsTemplateId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.smsTemplateList
        self.viewModel = CreateSMSTemplateViewModel(delegate: self)
        self.isCustom.setOn(false, animated: false)
        self.getSMSTemplate()
        self.collectionView.register(UINib(nibName: "CreateSMSTemplateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CreateSMSTemplateCollectionViewCell")
        self.setVarableData(selectedSegmentIndex: selectedIndex)
    }
    
    func getSMSTemplate(){
        if self.screenTitle == "Edit" {
            self.view.ShowSpinner()
            self.viewModel?.getSMSTemplateData(smsTemplateId: smsTemplateId)
        }else{
            self.view.ShowSpinner()
            self.viewModel?.getMassSMSVariablesList()
        }
    }
    
    func setVarableData(selectedSegmentIndex: Int) {
        switch selectedSegmentIndex {
        case 0:
            self.moduleTextField.text = "Lead"
            collectionView.reloadData()
        case 1:
            self.moduleTextField.text = "Appointment"
            collectionView.reloadData()
        case 2:
            self.moduleTextField.text = "Mass SMS"
            collectionView.reloadData()
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
        let moduleArray = ["Lead","Clinic"]
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
        
        let param: [String: Any] = [
            "id": self.smsTemplateId,
            "name": self.nameTextField.text ?? "",
            "body": self.bodyTextView.text ?? "",
            "templateFor": self.moduleTextField.text ?? "",
            "smsTemplateName": "",
            "isCustom": self.isCustom.isSelected,
            "smsTarget": self.targetTextField.text ?? ""
        ]
        if screenTitle == "Edit" {
            self.view.ShowSpinner()
            viewModel?.updateSMSTemplate(smsTemplatesId: smsTemplateId, parameters: param)
        }else{
            self.view.ShowSpinner()
            viewModel?.crateSMSTemplate(parameters: param)
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
        self.navigationController?.popViewController(animated: true)
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}

extension CreateSMSTemplateViewController: CreateSMSTemplateCollectionViewCellDelegate {
  
    func selectVariable(cell: CreateSMSTemplateCollectionViewCell, index: IndexPath) {
        let variable = viewModel?.getMassSMSTemplateListData(index: index.row).variable
        let str: String = " ${\(variable ?? "")} "
        self.bodyTextView.text += str
    }
}
