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
    func clinicRemovedSuccefully(message: String)
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
        guard let createClinicsVC = UIViewController.loadStoryboard("ClinicsListDetailViewController", "ClinicsListDetailViewController") as? ClinicsListDetailViewController else {
            fatalError("Failed to load ClinicsListDetailViewController from storyboard.")
        }
        createClinicsVC.screenTitle = Constant.Profile.createClinic
        self.navigationController?.pushViewController(createClinicsVC, animated: true)
    }
    
    func addEditClinicsView() {
        //        let createClinicsVC = UIStoryboard(name: "ClinicsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "ClinicsAddViewController") as! ClinicsAddViewController
        //        self.navigationController?.pushViewController(createClinicsVC, animated: true)
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
        self.clinicsListTableView.setContentOffset(.zero, animated: true)
        self.clinicsListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}

extension ClinicsListViewController: UITableViewDelegate, UITableViewDataSource, ClinicsListCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getClinicsFilterListData.count ?? 0 == 0 {
                self.clinicsListTableView.setEmptyMessage()
            } else {
                self.clinicsListTableView.restore()
            }
            return viewModel?.getClinicsFilterListData.count ?? 0
        } else {
            if viewModel?.getClinicsListData.count ?? 0 == 0 {
                self.clinicsListTableView.setEmptyMessage()
            } else {
                self.clinicsListTableView.restore()
            }
            return viewModel?.getClinicsListData.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)}).count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ClinicsListTableViewCell()
        cell.delegate = self
        cell = clinicsListTableView.dequeueReusableCell(withIdentifier: "ClinicsListTableViewCell") as! ClinicsListTableViewCell
        if isSearch {
            cell.configureCell(clinicsFilterList: viewModel, index: indexPath, isSearch: isSearch)
        } else {
            cell.configureCell(clinicsListData: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clinicDetailVC = UIStoryboard(name: "ClinicsListDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "ClinicsListDetailViewController") as! ClinicsListDetailViewController
        clinicDetailVC.screenTitle = Constant.Profile.editClinic
        if isSearch {
            clinicDetailVC.clinicId = viewModel?.getClinicsFilterListData[indexPath.row].id
        } else {
            clinicDetailVC.clinicId = viewModel?.getClinicsListData[indexPath.row].id
        }
        self.navigationController?.pushViewController(clinicDetailVC, animated: true)
    }
    
    func editClinic(cell: ClinicsListTableViewCell, index: IndexPath) {
        let clinicDetailVC = UIStoryboard(name: "ClinicsListDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "ClinicsListDetailViewController") as! ClinicsListDetailViewController
        clinicDetailVC.screenTitle = Constant.Profile.editClinic
        if isSearch {
            clinicDetailVC.clinicId = viewModel?.getClinicsFilterListData[index.row].id
        } else {
            clinicDetailVC.clinicId = viewModel?.getClinicsListData[index.row].id
        }
        self.navigationController?.pushViewController(clinicDetailVC, animated: true)
    }
    
    func removeSelectedClinic(cell: ClinicsListTableViewCell, index: IndexPath) {
        var selectedClinicId = Int()
        if isSearch {
            selectedClinicId = viewModel?.getClinicsFilterListData[index.row].id ?? 0
            let alert = UIAlertController(title: "Delete Clinic", message: "Are you sure you want to delete \(viewModel?.getClinicsFilterDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
            let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                            handler: { [weak self] _ in
                self?.view.ShowSpinner()
                self?.viewModel?.removeSelectedClinic(clinicId: selectedClinicId)
            })
            cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAlert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            selectedClinicId = viewModel?.getClinicsListData[index.row].id ?? 0
            let alert = UIAlertController(title: "Delete Clinic", message: "Are you sure you want to delete \(viewModel?.getClinicsDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
            let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                            handler: { [weak self] _ in
                self?.view.ShowSpinner()
                self?.viewModel?.removeSelectedClinic(clinicId: selectedClinicId)
            })
            cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAlert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func clinicRemovedSuccefully(message: String) {
        self.getClinicsList()
    }
}

extension ClinicsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getClinicsFilterData(searchText: searchText)
        isSearch = true
        clinicsListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        clinicsListTableView.reloadData()
    }
}

