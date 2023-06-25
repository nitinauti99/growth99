//
//  AuditListViewController.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol AuditListViewControllerProtocol: AnyObject {
    func auditListDataRecived()
    func auditListDetailInfoDataRecived(htmlContent: String)
    func errorReceived(error: String)
}

class AuditListViewController: UIViewController, AuditListViewControllerProtocol {
    
    @IBOutlet weak var auditListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: AuditListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [AuditListModel]()
    var auditIdInfo: Int = 0
    var communicationTypeStr: String = ""
    var triggerModuleStr: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        getAuditListInfo()
        registerTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AuditListViewModel(delegate: self)
        setUpNavigationBar()
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }
    
    @objc func getAuditListInfo() {
        self.view.ShowSpinner()
        viewModel?.getAuditInformation(auditId: auditIdInfo, communicationType: communicationTypeStr, triggerModule: triggerModuleStr)
    }
    
    func setUpNavigationBar() {
        self.title = "Trigger Audit"
    }
    
    func clearSearchBar() {
        isSearch = false
        searchBar.text = ""
        auditListTableView.reloadData()
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = Constant.Profile.searchList
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func registerTableView() {
        self.auditListTableView.delegate = self
        self.auditListTableView.dataSource = self
        auditListTableView.register(UINib(nibName: "AuditListTableViewCell", bundle: nil), forCellReuseIdentifier: "AuditListTableViewCell")
    }
    
    func auditListDataRecived() {
        self.view.HideSpinner()
        self.auditListTableView.setContentOffset(.zero, animated: true)
        self.auditListTableView.reloadData()
    }
    
    func auditListDetailInfoDataRecived(htmlContent: String) {
        self.view.HideSpinner()
        let showAuditDetailList = UIStoryboard(name: "AuditListDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "AuditListDetailViewController") as! AuditListDetailViewController
        showAuditDetailList.urlContentInfo = htmlContent
        self.navigationController?.pushViewController(showAuditDetailList, animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension AuditListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getAuditListFilterData(searchText: searchText)
        isSearch = true
        auditListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        auditListTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension AuditListViewController: AuditListTableViewCellDelegate {
    func auditBodyButtonPressed(cell: AuditListTableViewCell, index: IndexPath) {
        self.view.ShowSpinner()
        if isSearch {
            viewModel?.getAuditDetailInformation(auditContentId: viewModel?.getAuditListFilterDataAtIndex(index: index.row)?.contentId ?? 0)
        } else {
            viewModel?.getAuditDetailInformation(auditContentId: viewModel?.getAuditListDataAtIndex(index: index.row)?.contentId ?? 0)
        }
    }
}
