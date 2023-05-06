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
    func savePateintsTagList(responseMessage:String)
    func errorReceived(error: String)
}

class LeadTagsAddViewController: UIViewController {
    
    @IBOutlet weak var LeadTagsTextField: CustomTextField!
    @IBOutlet weak var LeadTagsLBI: UILabel!
    
    var viewModel: LeadTagsAddViewModelProtocol?
    var leadTagsList: [LeadTagListModel]?
    var leadTagId = Int()
    var leadTagScreenName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LeadTagsAddViewModel(delegate: self)
        if leadTagScreenName == "Edit Screen" {
            self.view.ShowSpinner()
            viewModel?.LeadTagsDetails(leadTagId: leadTagId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if leadTagScreenName == "Edit Screen" {
            self.LeadTagsLBI.text = "Edit Lead Tag"
            self.title = Constant.Profile.editLeadTags
            self.LeadTagsTextField.text = viewModel?.LeadTagsDetailsData?.name ?? String.blank
        }else{
            self.LeadTagsLBI.text = "Create Lead Tag"
            self.title = Constant.Profile.addLeadTags
        }
    }
    
    @objc func SendtoPatientButtonTapped(_ sender: UIButton) {
        self.view.ShowSpinner()
    }

    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        if let textField = LeadTagsTextField.text,  textField == "" {
            LeadTagsTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        if leadTagScreenName == "Edit Screen" {
            if let isValuePresent = self.leadTagsList?.filter({ $0.name?.lowercased() == self.LeadTagsTextField.text}), isValuePresent.count > 0 {
                self.LeadTagsTextField.showError(message: "Tag with this name already present.")
                return
            }
            self.view.ShowSpinner()
            self.viewModel?.saveLeadTagsDetails(leadTagId: leadTagId, name: LeadTagsTextField.text ?? String.blank)
        }else{
            if let isValuePresent = self.leadTagsList?.filter({ $0.name?.lowercased() == self.LeadTagsTextField.text}), isValuePresent.count > 0 {
                self.LeadTagsTextField.showError(message: "Tag with this name already present.")
                return
            }
            self.view.ShowSpinner()
            self.viewModel?.createLeadTagsDetails(name: LeadTagsTextField.text ?? String.blank)
        }
    }
    
}

extension LeadTagsAddViewController: LeadTagsAddViewControllerProtocol {
    func pateintsTagListRecived() {
        self.view.HideSpinner()
        if leadTagScreenName == "Edit Screen" {
            self.LeadTagsTextField.text = viewModel?.LeadTagsDetailsData?.name ?? String.blank
        }
    }
    
    func savePateintsTagList(responseMessage:String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}
