//
//  ClinicsListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

protocol ClinicsListViewContollerProtocol: AnyObject {
    func ClinicsDataRecived()
    func errorReceived(error: String)
}

class ClinicsListViewController: UIViewController, ClinicsListViewContollerProtocol {
    
    @IBOutlet private weak var clinicsListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: ClinicsListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [ClinicsListModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.getClinicsList()
        self.registerTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ClinicsListViewModel(delegate: self)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.clinics
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addButtonTapped), imageName: "add")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        //        let createClinicsVC = UIStoryboard(name: "ClinicsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "ClinicsAddViewController") as! ClinicsAddViewController
        //        self.navigationController?.pushViewController(createClinicsVC, animated: true)
    }
    
    func addEditClinicsView() {
        //        let createClinicsVC = UIStoryboard(name: "ClinicsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "ClinicsAddViewController") as! ClinicsAddViewController
        //        self.navigationController?.pushViewController(createClinicsVC, animated: true)
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func registerTableView() {
        self.clinicsListTableView.delegate = self
        self.clinicsListTableView.dataSource = self
        clinicsListTableView.register(UINib(nibName: "ClinicsListTableViewCell", bundle: nil), forCellReuseIdentifier: "ClinicsListTableViewCell")
    }
    
    @objc func getClinicsList() {
        self.view.ShowSpinner()
        viewModel?.getClinicsList()
    }
    
    func ClinicsDataRecived() {
        self.view.HideSpinner()
        self.clinicsListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension ClinicsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filteredTableData.count
        }else{
            return viewModel?.clinicsData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ClinicsListTableViewCell()
        cell = clinicsListTableView.dequeueReusableCell(withIdentifier: "ClinicsListTableViewCell") as! ClinicsListTableViewCell
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
        //        let createClinicsVC = UIStoryboard(name: "ClinicsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "ClinicsAddViewController") as! ClinicsAddViewController
        ////        createClinicsVC.selectedCategoryID = viewModel?.userData[indexPath.row].id ?? 0
        ////        createClinicsVC.screenTitle = Constant.Profile.editClinics
        //        self.navigationController?.pushViewController(createClinicsVC, animated: true)
    }
}

extension ClinicsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.clinicsData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        clinicsListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        clinicsListTableView.reloadData()
    }
}

