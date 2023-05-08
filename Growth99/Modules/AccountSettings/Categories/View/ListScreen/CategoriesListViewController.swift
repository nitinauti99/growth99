//
//  CategoriesListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

protocol CategoriesListViewContollerProtocol: AnyObject {
    func CategoriesDataRecived()
    func errorReceived(error: String)
    func categoriesRemovedSuccefully(message: String)
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
        self.getCategoriesList()
        self.registerTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CategoriesListViewModel(delegate: self)
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
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func registerTableView() {
        self.categoriesListTableView.delegate = self
        self.categoriesListTableView.dataSource = self
        categoriesListTableView.register(UINib(nibName: "CategoriesListTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesListTableViewCell")
    }
    
    @objc func getCategoriesList() {
        self.view.ShowSpinner()
        viewModel?.getCategoriesList()
    }
    
    func CategoriesDataRecived() {
        self.view.HideSpinner()
        self.categoriesListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension CategoriesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getCategoriesFilterListData.count ?? 0 == 0 {
                self.categoriesListTableView.setEmptyMessage()
            } else {
                self.categoriesListTableView.restore()
            }
            return viewModel?.getCategoriesFilterListData.count ?? 0
        } else {
            if viewModel?.getCategoriesListData.count ?? 0 == 0 {
                self.categoriesListTableView.setEmptyMessage()
            } else {
                self.categoriesListTableView.restore()
            }
            return viewModel?.getCategoriesListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = CategoriesListTableViewCell()
        cell = categoriesListTableView.dequeueReusableCell(withIdentifier: "CategoriesListTableViewCell") as! CategoriesListTableViewCell
        cell.delegate = self
        if isSearch {
            cell.configureCell(categoriesFilterList: viewModel, index: indexPath, isSearch: isSearch)
        } else {
            cell.configureCell(categoriesListData: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createCategoriesVC = UIStoryboard(name: "CategoriesAddViewController", bundle: nil).instantiateViewController(withIdentifier: "CategoriesAddViewController") as! CategoriesAddViewController
        createCategoriesVC.screenTitle = Constant.Profile.editCategories
        if isSearch {
            createCategoriesVC.categoryId = viewModel?.getCategoriesFilterListData[indexPath.row].id
        } else {
            createCategoriesVC.categoryId = viewModel?.getCategoriesListData[indexPath.row].id
        }
        self.navigationController?.pushViewController(createCategoriesVC, animated: true)
    }
}

extension CategoriesListViewController: CategoriesListCellDelegate {
    
    func editCategories(cell: CategoriesListTableViewCell, index: IndexPath) {
        let createCategoriesVC = UIStoryboard(name: "CategoriesAddViewController", bundle: nil).instantiateViewController(withIdentifier: "CategoriesAddViewController") as! CategoriesAddViewController
        createCategoriesVC.screenTitle = Constant.Profile.editCategories
        if isSearch {
            createCategoriesVC.categoryId = viewModel?.getCategoriesFilterListData[index.row].id
        } else {
            createCategoriesVC.categoryId = viewModel?.getCategoriesListData[index.row].id
        }
        self.navigationController?.pushViewController(createCategoriesVC, animated: true)
    }
    
    func removeSelectedCategorie(cell: CategoriesListTableViewCell, index: IndexPath) {
        var selectedClinicId = Int()
        if isSearch {
            selectedClinicId = viewModel?.getCategoriesFilterListData[index.row].id ?? 0
            let alert = UIAlertController(title: "Delete Category", message: "Are you sure you want to delete \(viewModel?.getCategoriesFilterDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
            let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
                self?.view.ShowSpinner()
                self?.viewModel?.removeSelectedCategorie(categorieId: selectedClinicId)
            })
            cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAlert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            selectedClinicId = viewModel?.getCategoriesListData[index.row].id ?? 0
            let alert = UIAlertController(title: "Delete Category", message: "Are you sure you want to delete \(viewModel?.getCategoriesDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
            let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
                self?.view.ShowSpinner()
                self?.viewModel?.removeSelectedCategorie(categorieId: selectedClinicId)
            })
            cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAlert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func categoriesRemovedSuccefully(message: String){
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        self.getCategoriesList()
    }
}

extension CategoriesListViewController:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getCategoriesFilterData(searchText: searchText)
        isSearch = true
        categoriesListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        categoriesListTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
