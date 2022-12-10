//
//  leadViewController.swift
//  Growth99
//
//  Created by nitin auti on 28/11/22.
//

import Foundation
import UIKit

protocol leadViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class leadViewController: UIViewController, leadViewControllerProtocol {
   
    @IBOutlet private weak var leadListTableView: UITableView!
    var viewModel: leadViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
        self.viewModel = leadViewModel(delegate: self)
        self.getLeadList()
        self.setUpUI()
     }
    
    func registerTableView() {
        self.leadListTableView.delegate = self
        self.leadListTableView.dataSource = self
        leadListTableView.register(UINib(nibName: "LeadHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadHeaderTableViewCell")
        leadListTableView.register(UINib(nibName: "LeadTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadTableViewCell")
    }
    
    func setUpUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(creatLead))
    }
    
    @objc func creatLead() {
        let createLeadVC = UIStoryboard(name: "CreateLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateLeadViewController") as! CreateLeadViewController
        self.present(createLeadVC, animated: true)
    }
    
    func getLeadList(){
        self.view.ShowSpinner()
        viewModel?.getLeadList(page: 0, size: 50, statusFilter: "", sourceFilter: "", search: "", leadTagFilter: "")
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.leadListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
    }
}

extension leadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((viewModel?.LeadUserData?.count ?? 0) - 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = LeadTableViewCell()
        cell = leadListTableView.dequeueReusableCell(withIdentifier: "LeadTableViewCell") as! LeadTableViewCell
        cell.configureCell(leadVM: viewModel, index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "leadDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "leadDetailViewController") as! leadDetailViewController
       // detailController?.delegate = self
        detailController.LeadData = viewModel?.leadDataAtIndex(index: indexPath.row)
        navigationController?.pushViewController(detailController, animated: true)
    }
    
}
