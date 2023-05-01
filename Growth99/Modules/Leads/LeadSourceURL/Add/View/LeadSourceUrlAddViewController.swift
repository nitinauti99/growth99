//
//  AddLeadSourceUrlListViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
import UIKit

protocol LeadSourceUrlAddViewControllerProtocol: AnyObject {
    func leadSourceUrlListRecived()
    func errorReceived(error: String)
    func updateLeadSourceUrlList(message:String)
    func createdLeadSourceUrlList(message:String)
}

class LeadSourceUrlAddViewController: UIViewController, LeadSourceUrlAddViewControllerProtocol {
    
    @IBOutlet weak var leadSourceUrlTextField: CustomTextField!
    @IBOutlet weak var leadSourceUrlLBI: UILabel!
    
    var viewModel: LeadSourceUrlAddViewModelProtocol?
    var leadSourceUrlId = Int()
    var leadTagScreenName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LeadSourceUrlAddViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if leadTagScreenName == "Edit Screen" {
            self.view.ShowSpinner()
            viewModel?.LeadSourceUrlDetails(leadTagId: leadSourceUrlId)
        }
        if leadTagScreenName == "Edit Screen" {
            self.leadSourceUrlLBI.text = "Edit Lead Source URL"
            self.title = Constant.Profile.editLeadSourceURL
        } else {
            self.leadSourceUrlLBI.text = "Create Lead Source URL"
            self.title = Constant.Profile.addLeadSourceURL
        }
    }
    
    func leadSourceUrlListRecived() {
        self.view.HideSpinner()
        if leadTagScreenName == "Edit Screen" {
            self.leadSourceUrlTextField.text = viewModel?.LeadSourceUrlDetailsData?.sourceUrl ?? String.blank
        }
    }
    
    func createdLeadSourceUrlList(message: String) {
        self.view.HideSpinner()
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateLeadSourceUrlList(message:String) {
        self.view.HideSpinner()
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        guard let textField = leadSourceUrlTextField.text, !textField.isEmpty else {
            leadSourceUrlTextField.showError(message: "Source URL is required.")
            return
        }
        self.view.ShowSpinner()
        if leadTagScreenName == "Edit Screen" {
            viewModel?.updateLeadSourceUrlDetails(leadTagId: leadSourceUrlId, name: leadSourceUrlTextField.text ?? String.blank)
        } else {
            viewModel?.createLeadSourceUrlDetails(name: leadSourceUrlTextField.text ?? String.blank)
        }
    }
}
