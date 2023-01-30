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
}

class PateintsTagsAddViewController: UIViewController, PateintsTagsAddViewControllerProtocol {
   
    @IBOutlet private weak var PateintsTagsTextField: CustomTextField!
    var viewModel: PateintsTagsAddViewModelProtocol?
    var PatientTagId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PateintsTagsAddViewModel(delegate: self)
        self.view.ShowSpinner()
        viewModel?.pateintsTagsDetails(pateintsTagId: PatientTagId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.Questionnarie
        PateintsTagsTextField.text = viewModel?.pateintsTagsDetailsData?.name ?? ""
    }
    
    func pateintsTagListRecived() {
        self.view.HideSpinner()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    @objc func SendtoPatientButtonTapped(_ sender: UIButton) {
        self.view.ShowSpinner()
    }
    
}
