//
//  ServicesListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

protocol ServicesListViewContollerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class ServicesListViewController: UIViewController, ServicesListViewContollerProtocol {

    @IBOutlet private weak var servicesListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var viewModel: ServicesListViewModelProtocol?
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
        self.viewModel = ServicesListViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.services
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addButtonTapped), imageName: "add")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
//        let createServicesVC = UIStoryboard(name: "ServicesAddViewController", bundle: nil).instantiateViewController(withIdentifier: "ServicesAddViewController") as! ServicesAddViewController
//        self.navigationController?.pushViewController(createServicesVC, animated: true)
    }
    
    func addEditServicesView() {
//        let createServicesVC = UIStoryboard(name: "ServicesAddViewController", bundle: nil).instantiateViewController(withIdentifier: "ServicesAddViewController") as! ServicesAddViewController
//        self.navigationController?.pushViewController(createServicesVC, animated: true)
    }
    
    @objc func updateUI(){
        self.getUserList()
        self.view.ShowSpinner()
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
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
        viewModel?.getUserList()
    }
//
//    func loadMoreItemsForList(){
//        if (viewModel?.leadUserData.count ?? 0) ==  viewModel?.leadTotalCount {
//            return
//        }
//         currentPage += 1
//         getListFromServer(currentPage)
//     }
    
    func registerTableView() {
        self.servicesListTableView.delegate = self
        self.servicesListTableView.dataSource = self
        servicesListTableView.register(UINib(nibName: "ServicesListTableViewCell", bundle: nil), forCellReuseIdentifier: "ServicesListTableViewCell")
    }

    @objc func getUserList(){
        self.view.ShowSpinner()
        viewModel?.getUserList()
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.servicesListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension ServicesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
           return filteredTableData.count
        }else{
            return viewModel?.userData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ServicesListTableViewCell()
        cell = servicesListTableView.dequeueReusableCell(withIdentifier: "ServicesListTableViewCell") as! ServicesListTableViewCell
        if isSearch {
            cell.configureCell(userVM: viewModel, index: indexPath)
        } else {
            cell.configureCell(userVM: viewModel, index: indexPath)

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let createServicesVC = UIStoryboard(name: "ServicesAddViewController", bundle: nil).instantiateViewController(withIdentifier: "ServicesAddViewController") as! ServicesAddViewController
////        createServicesVC.selectedCategoryID = viewModel?.userData[indexPath.row].id ?? 0
////        createServicesVC.screenTitle = Constant.Profile.editServices
//        self.navigationController?.pushViewController(createServicesVC, animated: true)
    }
}

extension ServicesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredTableData = (viewModel?.userData.filter { $0.[0]name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
//        isSearch = true
//        servicesListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        isSearch = false
//        searchBar.text = ""
//        servicesListTableView.reloadData()
    }
}

