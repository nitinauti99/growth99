//
//  leadTimeLineViewController.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation
import UIKit

protocol leadTimeLineViewControllerProtocol: AnyObject {
    func errorReceived(error: String)
    func recivedLeadCreation()
    func recivedAuditLeadList()
}

class leadTimeLineViewController: UIViewController,
                                  leadTimeLineViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: leadTimeLineViewModelProtocol?
    var leadId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = leadTimeLineViewModel(delegate: self)
        tableView.register(UINib(nibName: "leadTimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "leadTimeLineTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.Timeline
        self.view.ShowSpinner()
        viewModel?.getLeadTimeData(leadId: leadId)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
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
