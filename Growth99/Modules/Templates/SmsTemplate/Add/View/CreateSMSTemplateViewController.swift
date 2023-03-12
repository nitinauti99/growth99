//
//  CreateSMSTemplateViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation
import UIKit

protocol CreateSMSTemplateViewControllerProtocol {
    func smsVarableTListDataRecived()
    func errorReceived(error: String)
}

class CreateSMSTemplateViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moduleTextField: CustomTextField!
    @IBOutlet weak var targetTextField: CustomTextField!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var bodyTextView: CustomTextView!

    @IBOutlet weak var isCustom: UISwitch!

    var viewModel: CreateSMSTemplateViewModelProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.smsTemplateList
        self.viewModel = CreateSMSTemplateViewModel(delegate: self)
        self.view.ShowSpinner()
        self.viewModel?.getCreateSMSTemplateList()
        self.collectionView.register(UINib(nibName: "CreateSMSTemplateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CreateSMSTemplateCollectionViewCell")
    }
    
    @IBAction func selectModuleAction(sender: UIButton){
        let moduleArray = ["Lead","Appointment", "Mass SMS"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: moduleArray, cellType: .subTitle) { (cell, module, indexPath) in
            cell.textLabel?.text = module
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            selectionMenu.dismissAutomatically = true
            self?.moduleTextField.text  = text
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(moduleArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectTargetAction(sender: UIButton){
        let moduleArray = ["Lead","Clinic"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: moduleArray, cellType: .subTitle) { (cell, module, indexPath) in
            cell.textLabel?.text = module
            self.targetTextField.text  = module
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            selectionMenu.dismissAutomatically = true
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(moduleArray.count * 44))), arrowDirection: .up), from: self)
    }
    
}

extension CreateSMSTemplateViewController: CreateSMSTemplateViewControllerProtocol {
   
    func smsVarableTListDataRecived(){
        self.view.HideSpinner()
        collectionView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
