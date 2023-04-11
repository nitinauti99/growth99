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
    
    @IBOutlet weak var PateintsTagsTextField: CustomTextField!
    @IBOutlet weak var pateintsTagsLBI: UILabel!
    
    var viewModel: PateintsTagsAddViewModelProtocol?
    var patientTagId = Int()
    var pateintsTagScreenName = String()
    var pateintsTagsList: [PateintsTagListModel]?

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
        if pateintsTagScreenName == "Edit Screen" {
            self.pateintsTagsLBI.text = "Edit Patient Tag"
            self.title = Constant.Profile.editPatientTags
            self.PateintsTagsTextField.text = viewModel?.pateintsTagsDetailsData?.name ?? String.blank
        }else{
            self.pateintsTagsLBI.text = "Create Patient Tag"
            self.title = Constant.Profile.createPatientTags
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
        self.view.showToast(message: error, color: .red)
    }
    
    @objc func SendtoPatientButtonTapped(_ sender: UIButton) {
        self.view.ShowSpinner()
    }
    
    func savePateintsTagList(responseMessage:String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        if let textField = PateintsTagsTextField.text,  textField == "" {
            PateintsTagsTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        if pateintsTagScreenName == "Edit Screen" {
            self.view.ShowSpinner()
            viewModel?.savePateintsTagsDetails(pateintsTagId: patientTagId, name: PateintsTagsTextField.text ?? String.blank)
        }else{
            if let isValuePresent = self.pateintsTagsList?.filter({ $0.name?.lowercased() == self.PateintsTagsTextField.text}), isValuePresent.count > 0 {
                PateintsTagsTextField.showError(message: "Tag with this name already present.")
                return
            }
            self.view.ShowSpinner()
            viewModel?.createPateintsTagsDetails(name: PateintsTagsTextField.text ?? String.blank)
        }
    }
    
}
