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

class leadTimeLineViewController: UIViewController,leadTimeLineViewControllerProtocol {
    
    @IBOutlet private weak var leadTimeLineTableView: UITableView!
    
    private var viewModel: leadTimeLineViewModelProtocol?
    var LeadData: leadModel?
    var list = [auditLeadModel]()
    var LeadId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = leadTimeLineViewModel(delegate: self)
        leadTimeLineTableView.register(UINib(nibName: "leadTimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "leadTimeLineTableViewCell")
        
        leadTimeLineTableView.register(UINib(nibName: "leadTimeLineHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "leadTimeLineHeaderTableViewCell")
        self.view.ShowSpinner()
        viewModel?.leadCreation(leadId: LeadId ?? 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.Timeline

    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    func recivedLeadCreation() {
        viewModel?.auditLeadList(leadId: LeadId ?? 0)
    }
    
    func recivedAuditLeadList() {
        self.view.HideSpinner()
        list = viewModel?.leadCreatiionData ?? []
        self.leadTimeLineTableView.reloadData()
    }
}

extension leadTimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = leadTimeLineHeaderTableViewCell()
        let item = viewModel?.leadCreationData
        cell = leadTimeLineTableView.dequeueReusableCell(withIdentifier: "leadTimeLineHeaderTableViewCell") as! leadTimeLineHeaderTableViewCell
        cell.name.text = "\(item?.firstName  ?? "") \(item?.lastName ?? "")"
        cell.createdDateTime.text = item?.createdAt
        cell.type.text = "Lead Crated"
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = leadTimeLineTableViewCell()
        let item = list[indexPath.row]
        cell = leadTimeLineTableView.dequeueReusableCell(withIdentifier: "leadTimeLineTableViewCell") as! leadTimeLineTableViewCell
        cell.name.text = item.name
        cell.createdDateTime.text = item.createdDateTime
        cell.email.text = item.email
        cell.type.text = item.type
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 180
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
   
}
