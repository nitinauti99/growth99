//
//  ServicesListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

protocol ServicesListViewContollerProtocol: AnyObject {
    func serviceListDataRecived()
    func errorReceived(error: String)
    func serviceRemovedSuccefully(message: String)
}

class ServicesListViewController: UIViewController, ServicesListViewContollerProtocol {
    
    @IBOutlet weak var servicesListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: ServiceListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [ServiceList]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.getUserList()
        self.registerTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ServiceListViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.services
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addButtonTapped), imageName: "add")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        guard let createServiceVC = UIViewController.loadStoryboard("ServicesListDetailViewController", "ServicesListDetailViewController") as? ServicesListDetailViewController else {
            fatalError("Failed to load ServicesListDetailViewController from storyboard.")
        }
        createServiceVC.screenTitle = Constant.Profile.createService
        self.navigationController?.pushViewController(createServiceVC, animated: true)
    }
    
    func addEditServicesView() {
        
    }
    
    @objc func updateUI() {
        self.getUserList()
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getUserList()
    }
    
    func getListFromServer(_ pageNumber: Int){
        self.view.ShowSpinner()
        viewModel?.getServiceList()
    }
    
    func registerTableView() {
        self.servicesListTableView.delegate = self
        self.servicesListTableView.dataSource = self
        servicesListTableView.register(UINib(nibName: "ServicesListTableViewCell", bundle: nil), forCellReuseIdentifier: "ServicesListTableViewCell")
    }
    
    @objc func getUserList(){
        self.view.ShowSpinner()
        viewModel?.getServiceList()
    }
    
    func serviceListDataRecived() {
        self.view.HideSpinner()
        self.servicesListTableView.setContentOffset(.zero, animated: false)
        self.servicesListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func serviceRemovedSuccefully(message: String) {
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        self.getUserList()
    }
    
}

