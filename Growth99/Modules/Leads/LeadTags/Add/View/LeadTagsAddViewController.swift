//
//  LeadTagsAddViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
import UIKit

protocol LeadTagsAddViewControllerProtocol: AnyObject {
    func pateintsTagListRecived()
    func errorReceived(error: String)
    func savePateintsTagList(responseMessage:String)
}

class LeadTagsAddViewController: UIViewController, LeadTagsAddViewControllerProtocol {
    
    @IBOutlet private weak var LeadTagsTextField: CustomTextField!
    @IBOutlet private weak var LeadTagsLBI: UILabel!
    
    var viewModel: LeadTagsAddViewModelProtocol?
    var patientTagId = Int()
    var leadTagScreenName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LeadTagsAddViewModel(delegate: self)
        if leadTagScreenName == "Edit Screen" {
            self.view.ShowSpinner()
            viewModel?.LeadTagsDetails(leadTagId: patientTagId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if leadTagScreenName == "Edit Screen" {
            self.LeadTagsLBI.text = "Edit Lead Tag"
            self.title = Constant.Profile.editPatientTags
            self.LeadTagsTextField.text = viewModel?.LeadTagsDetailsData?.name ?? String.blank
        }else{
            self.LeadTagsLBI.text = "Create Lead Tag"
            self.title = Constant.Profile.createPatientTags
        }
    }
    
    func pateintsTagListRecived() {
        self.view.HideSpinner()
        if leadTagScreenName == "Edit Screen" {
            self.LeadTagsTextField.text = viewModel?.LeadTagsDetailsData?.name ?? String.blank
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    @objc func SendtoPatientButtonTapped(_ sender: UIButton) {
        self.view.ShowSpinner()
    }
    
    func savePateintsTagList(responseMessage:String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: .black)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        if let textField = LeadTagsTextField.text,  textField == "" {
            LeadTagsTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
        }
        self.view.ShowSpinner()
        if leadTagScreenName == "Edit Screen" {
            viewModel?.saveLeadTagsDetails(leadTagId: patientTagId, name: LeadTagsTextField.text ?? String.blank)
        }else{
            viewModel?.createLeadTagsDetails(name: LeadTagsTextField.text ?? String.blank)
        }
    }
    
}
