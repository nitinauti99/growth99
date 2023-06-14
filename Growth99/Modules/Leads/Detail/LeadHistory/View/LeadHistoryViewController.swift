//
//  LeadHistoryViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation
import UIKit

protocol LeadHistoryViewControllerProtocol: AnyObject {
    func LeadHistoryDataRecived()
    func errorReceived(error: String)
    func leadRemovedSuccefully(message: String)

}

class LeadHistoryViewController: UIViewController, LeadHistoryViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: LeadHistoryViewModelProtocol?
    var isSearch : Bool = false
    let user = UserRepository.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LeadHistoryViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.registerTableView()
        self.title = Constant.Profile.leadHistroy
        self.view.ShowSpinner()
        self.viewModel?.getLeadHistory()
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }

    func registerTableView() {
        self.tableView.register(UINib(nibName: "LeadHistoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadHistoryListTableViewCell")
    }
    
    @objc func getUserList(){
        self.view.ShowSpinner()
        viewModel?.getLeadHistory()
    }
    
    func LeadHistoryDataRecived() {
        self.view.HideSpinner()
        self.tableView.setContentOffset(.zero, animated: true)
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func leadRemovedSuccefully(message: String){
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        viewModel?.getLeadHistory()
    }
}
extension LeadHistoryViewController: LeadHistoryListTableViewCellDelegate {
   
    func removeLead(cell: LeadHistoryListTableViewCell, index: IndexPath) {
        var fullName = String()
        var id = Int()
       
        if isSearch{
            fullName = (viewModel?.leadHistoryFilterDataAtIndex(index: index.row)?.firstName ?? "")  + (viewModel?.leadHistoryDataAtIndex(index: index.row)?.lastName ?? "")
            id = self.viewModel?.leadHistoryFilterDataAtIndex(index: index.row)?.id ?? 0
        }else{
            fullName = (viewModel?.leadHistoryDataAtIndex(index: index.row)?.firstName ?? "")  + (viewModel?.leadHistoryDataAtIndex(index: index.row)?.lastName ?? "")
            id = self.viewModel?.leadHistoryDataAtIndex(index: index.row)?.id ?? 0
        }
        
        let alert = UIAlertController(title: "Delete Lead", message: "Are you sure you want to delete \n\(fullName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeLeadFromHistry(id: id)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editLead(cell: LeadHistoryListTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "EditLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "EditLeadViewController") as! EditLeadViewController
        
        if isSearch{
            editVC.LeadData = viewModel?.leadHistoryFilterDataAtIndex(index: index.row)
            user.leadId = self.viewModel?.leadHistoryFilterDataAtIndex(index: index.row)?.id
            user.leadFullName = (viewModel?.leadHistoryFilterDataAtIndex(index: index.row)?.firstName ?? "") + " " + (viewModel?.leadHistoryFilterDataAtIndex(index: index.row)?.lastName ?? "")
        }else{
            editVC.LeadData = viewModel?.leadHistoryDataAtIndex(index: index.row)
            user.leadId = self.viewModel?.leadHistoryFilterDataAtIndex(index: index.row)?.id
            user.leadFullName = (viewModel?.leadHistoryFilterDataAtIndex(index: index.row)?.firstName ?? "") + " " + (viewModel?.leadHistoryFilterDataAtIndex(index: index.row)?.lastName ?? "")
        }
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}
