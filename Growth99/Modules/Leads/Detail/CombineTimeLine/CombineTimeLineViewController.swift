//
//  CombineTimeLineViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation
import UIKit

protocol CombineTimeLineViewControllerProtocol: AnyObject {
    func errorReceived(error: String)
    func recivedLeadCreation()
    func recivedAuditLeadList()
}

class CombineTimeLineViewController: UIViewController,
                                     CombineTimeLineViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CombineTimeLineViewModelProtocol?
    var leadId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CombineTimeLineViewModel(delegate: self)
        tableView.register(UINib(nibName: "LeadCombineTimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadCombineTimeLineTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.Timeline
        self.view.ShowSpinner()
        viewModel?.getLeadTimeData(leadId: leadId)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func recivedLeadCreation() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func recivedAuditLeadList() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
}
