//
//  PateintsTagsAddViewController.swift
//  Growth99
//
//  Created by nitin auti on 29/01/23.
//

import Foundation
import UIKit

protocol PateintsTagsAddViewControllerProtocol: AnyObject {
    func pateintsTagListRecived()
    func errorReceived(error: String)
    func savePateintsTagList(responseMessage:String)
}

class PateintsTagsAddViewController: UIViewController, PateintsTagsAddViewControllerProtocol {
    
    @IBOutlet private weak var PateintsTagsTextField: CustomTextField!
    @IBOutlet private weak var pateintsTagsLBI: UILabel!
    
    var viewModel: PateintsTagsAddViewModelProtocol?
    var patientTagId = Int()
    var pateintsTagScreenName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PateintsTagsAddViewModel(delegate: self)
        if pateintsTagScreenName == "Edit Screen" {
            self.view.ShowSpinner()
            viewModel?.pateintsTagsDetails(pateintsTagId: patientTagId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.Questionnarie
        if pateintsTagScreenName == "Edit Screen" {
            self.pateintsTagsLBI.text = "Edit Patient Tag"
            self.PateintsTagsTextField.text = viewModel?.pateintsTagsDetailsData?.name ?? String.blank
        }else{
            self.pateintsTagsLBI.text = "Create Patient Tag"
        }
    }
    
    func pateintsTagListRecived() {
        self.view.HideSpinner()
        if pateintsTagScreenName == "Edit Screen" {
            self.PateintsTagsTextField.text = viewModel?.pateintsTagsDetailsData?.name ?? String.blank
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
        if let textField = PateintsTagsTextField.text,  textField == "" {
            PateintsTagsTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
        }
        self.view.ShowSpinner()
        if PateintsTagsCreate == false {
            viewModel?.savePateintsTagsDetails(pateintsTagId: PatientTagId, name: PateintsTagsTextField.text ?? String.blank)
        }else{
            viewModel?.createPateintsTagsDetails(name: PateintsTagsTextField.text ?? String.blank)
        }
    }
    
}
