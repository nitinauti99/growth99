//
//  MassEmailandSMSViewController.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol MassEmailandSMSViewContollerProtocol: AnyObject {
    func massEmailandSMSDataRecived()
    func errorReceived(error: String)
}

class MassEmailandSMSViewController: UIViewController, MassEmailandSMSViewContollerProtocol {
    
    @IBOutlet weak var massEmailandSMSTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var massEmailSMSSegmentControl: UISegmentedControl!
    
    var viewModel: MassEmailandSMSViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [MassEmailandSMSModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        getMassEmailandSMS()
        registerTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MassEmailandSMSViewModel(delegate: self)
        setUpNavigationBar()
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }

    @objc func getMassEmailandSMS() {
        self.view.ShowSpinner()
        viewModel?.getMassEmailandSMS()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.massEmailSMS
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addButtonTapped), imageName: "add")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let addEventVC = UIStoryboard(name: Constant.ViewIdentifier.massEmailandSMSDetailVC, bundle: nil).instantiateViewController(withIdentifier: Constant.ViewIdentifier.massEmailandSMSDetailVC) as! MassEmailandSMSDetailViewController
        self.navigationController?.pushViewController(addEventVC, animated: true)
    }
    
    @IBAction func massEmailSMSSegmentSelection(_ sender: Any) {
        self.massEmailandSMSTableView.setContentOffset(.zero, animated: true)
        clearSearchBar()
    }
    
    func clearSearchBar() {
        isSearch = false
        searchBar.text = ""
        massEmailandSMSTableView.reloadData()
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
        self.massEmailandSMSTableView.delegate = self
        self.massEmailandSMSTableView.dataSource = self
        massEmailandSMSTableView.register(UINib(nibName: "MassEmailandSMSTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSTableViewCell")
    }
    
    func massEmailandSMSDataRecived() {
        self.view.HideSpinner()
        self.massEmailandSMSTableView.setContentOffset(.zero, animated: true)
        self.massEmailandSMSTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension MassEmailandSMSViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getMassEmailandSMSFilterData(searchText: searchText)
        isSearch = true
        massEmailandSMSTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        massEmailandSMSTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MassEmailandSMSViewController: MassEmailandSMSDelegate {
    func removeEmailandSMS(cell: MassEmailandSMSTableViewCell, index: IndexPath) {
        
    }
    
    func editEmailandSMS(cell: MassEmailandSMSTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "MassEmailandSMSDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "MassEmailandSMSDetailViewController") as! MassEmailandSMSDetailViewController
        if isSearch {
            editVC.massAppointmnentId = viewModel?.getMassEmailandSMSFilterData[index.row].id ?? 0
        } else {
            editVC.massAppointmnentId = viewModel?.getMassEmailandSMSData[index.row].id ?? 0
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func didTapSwitchButton(massEmailandSMSId: String, massEmailandSMSStatus: String) {
        self.view.ShowSpinner()
        viewModel?.getSwitchOnButton(massEmailandSMSId: massEmailandSMSId, massEmailandSMStatus: massEmailandSMSStatus)
    }
}
