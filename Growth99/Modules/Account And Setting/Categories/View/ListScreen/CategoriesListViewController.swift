//
//  CategoriesListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

protocol CategoriesListViewContollerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class CategoriesListViewController: UIViewController, CategoriesListViewContollerProtocol {

    @IBOutlet private weak var categoriesListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var viewModel: CategoriesListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [CategoriesListModel]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.getUserList()
        self.registerTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CategoriesListViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.categories
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addButtonTapped), imageName: "add")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let createCategoriesVC = UIStoryboard(name: "CategoriesAddViewController", bundle: nil).instantiateViewController(withIdentifier: "CategoriesAddViewController") as! CategoriesAddViewController
        self.navigationController?.pushViewController(createCategoriesVC, animated: true)
    }
    
    func addEditCategoriesView() {
        let createCategoriesVC = UIStoryboard(name: "CategoriesAddViewController", bundle: nil).instantiateViewController(withIdentifier: "CategoriesAddViewController") as! CategoriesAddViewController
        self.navigationController?.pushViewController(createCategoriesVC, animated: true)
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
        self.categoriesListTableView.delegate = self
        self.categoriesListTableView.dataSource = self
        categoriesListTableView.register(UINib(nibName: "CategoriesListTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesListTableViewCell")
    }

    @objc func getUserList(){
        self.view.ShowSpinner()
        viewModel?.getUserList()
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.categoriesListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension CategoriesListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        var cell = CategoriesListTableViewCell()
        cell = categoriesListTableView.dequeueReusableCell(withIdentifier: "CategoriesListTableViewCell") as! CategoriesListTableViewCell
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
        let createCategoriesVC = UIStoryboard(name: "CategoriesAddViewController", bundle: nil).instantiateViewController(withIdentifier: "CategoriesAddViewController") as! CategoriesAddViewController
//        createCategoriesVC.selectedCategoryID = viewModel?.userData[indexPath.row].id ?? 0
//        createCategoriesVC.screenTitle = Constant.Profile.editCategories
        self.navigationController?.pushViewController(createCategoriesVC, animated: true)
    }
}

extension CategoriesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.userData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        categoriesListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        categoriesListTableView.reloadData()
    }
}


