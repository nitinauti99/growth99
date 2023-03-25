//
//  CreateSocialProfileViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 18/03/23.
//

import Foundation
import UIKit

protocol CreateSocialProfileViewControllerProtocol: AnyObject {
    func createSocialProfileListRecived()
    func errorReceived(error: String)
    func saveCreateSocialList(responseMessage:String)
}

class CreateSocialProfileViewController: UIViewController {
    
    @IBOutlet private weak var createSocialTextField: CustomTextField!
    @IBOutlet private weak var LeadTagsLBI: UILabel!
    
    var viewModel: SocialProfileViewModelProtocol?
    var socialProfileId = Int()
    var socialProfilesScreenName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SocialProfileViewModel(delegate: self)
        if self.socialProfilesScreenName == "Edit Screen" {
            self.view.ShowSpinner()
            viewModel?.getSocialProfileDetails(socialProfileId: socialProfileId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.socialProfilesScreenName == "Edit Screen" {
            self.LeadTagsLBI.text = "Edit Channel"
            self.title = Constant.Profile.editPatientTags
            self.createSocialTextField.text = viewModel?.getSocialProfileDetailsData?.name ?? String.blank
        }else{
            self.LeadTagsLBI.text = "Create Channel"
            self.title = Constant.Profile.createPatientTags
        }
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        if let textField = createSocialTextField.text,  textField == "" {
            createSocialTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
            return
        }
        self.view.ShowSpinner()
        if self.socialProfilesScreenName == "Edit Screen" {
            viewModel?.upadteSocialProfileDetails(socialProfileId: self.socialProfileId, name: createSocialTextField.text ?? String.blank)
        }else{
            viewModel?.createSocialProfileDetails(name: self.createSocialTextField.text ?? String.blank)
        }
    }
    
}

extension CreateSocialProfileViewController: CreateSocialProfileViewControllerProtocol {
   
    func createSocialProfileListRecived() {
        self.view.HideSpinner()
        if self.socialProfilesScreenName == "Edit Screen" {
           self.createSocialTextField.text = viewModel?.getSocialProfileDetailsData?.name ?? String.blank
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
