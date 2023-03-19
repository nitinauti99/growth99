//
//  CreateLabelViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 18/03/23.
//

import Foundation
import UIKit

protocol CreateLabelViewControllerProtocol: AnyObject {
    func createCreateLabelListRecived()
    func errorReceived(error: String)
    func saveCreateSocialList(responseMessage:String)
}

class CreateLabelViewController: UIViewController {
    
    @IBOutlet private weak var createSocialTextField: CustomTextField!
    @IBOutlet private weak var LeadTagsLBI: UILabel!
    
    var viewModel: CreateLabelViewModelProtocol?
    var labelId = Int()
    var screenName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateLabelViewModel(delegate: self)
        if self.screenName == "Edit Screen" {
            self.view.ShowSpinner()
            viewModel?.getCreateLabelDetails(labelId: labelId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.screenName == "Edit Screen" {
            self.LeadTagsLBI.text = "Edit Post Label"
            self.title = Constant.Profile.editPatientTags
            self.createSocialTextField.text = viewModel?.getCreateLabelDetailsData?.name ?? String.blank
        }else{
            self.LeadTagsLBI.text = "Create Post Label"
            self.title = Constant.Profile.createPatientTags
        }
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        if let textField = createSocialTextField.text,  textField == "" {
            createSocialTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
        }
        self.view.ShowSpinner()
        if self.screenName == "Edit Screen" {
            viewModel?.upadteCreateLabelDetails(labelId: self.labelId, name: createSocialTextField.text ?? String.blank)
        }else{
            viewModel?.createLabelDetails(name: self.createSocialTextField.text ?? String.blank)
        }
    }
    
}

extension CreateLabelViewController: CreateLabelViewControllerProtocol {
   
    func createCreateLabelListRecived() {
        self.view.HideSpinner()
        if self.screenName == "Edit Screen" {
           self.createSocialTextField.text = viewModel?.getCreateLabelDetailsData?.name ?? String.blank
        }
    }
   
    func saveCreateSocialList(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: .black)
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}