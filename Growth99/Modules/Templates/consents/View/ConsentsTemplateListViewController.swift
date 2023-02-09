//
//  ConsentsViewController.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//

import Foundation
import UIKit

protocol ConsentsTemplateListViewControllerProtocol {
    func ConsentsTemplatesDataRecived()
    func errorReceived(error: String)
}

class ConsentsTemplateListViewController: UIViewController, ConsentsTemplateListViewControllerProtocol {
    
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: ConsentsTemplateListViewModelProtocol?
    
    var workflowTaskPatientId = Int()
    var selectedindex = 0
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.consentsTemplatesList
        viewModel = ConsentsTemplateListViewModel(delegate: self)
        viewModel?.getConsentsTemplateList()
        tableView.register(UINib(nibName: "ConsentsTemplateListTableViewCell", bundle: nil), forCellReuseIdentifier: "ConsentsTemplateListTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.register(UINib(nibName: "ConsentsTemplateListTableViewCell", bundle: nil), forCellReuseIdentifier: "ConsentsTemplateListTableViewCell")
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getPateintList()
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "CreatePateintViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintViewContoller") as! CreatePateintViewContoller
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }
    
    @objc func getPateintList() {
        self.view.ShowSpinner()
        viewModel?.getConsentsTemplateList()
    }
    
    
    func ConsentsTemplatesDataRecived(){
        self.view.HideSpinner()
        //ConsentsTemplateListData = viewModel?.getConsentsTemplateData ?? []
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
}
