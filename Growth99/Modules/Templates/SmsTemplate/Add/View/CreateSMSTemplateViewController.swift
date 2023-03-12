//
//  CreateSMSTemplateViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation
import UIKit

protocol CreateSMSTemplateViewControllerProtocol {
    func SmsTemplatesDataRecived()
    func errorReceived(error: String)
}

class CreateSMSTemplateViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: CreateSMSTemplateViewModelProtocol?
    
    var workflowTaskPatientId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.smsTemplateList
        self.viewModel = CreateSMSTemplateViewModel(delegate: self)
        self.view.ShowSpinner()
        self.viewModel?.getCreateSMSTemplateList()
    }

}

extension CreateSMSTemplateViewController: CreateSMSTemplateViewControllerProtocol {
   
    func SmsTemplatesDataRecived(){
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
