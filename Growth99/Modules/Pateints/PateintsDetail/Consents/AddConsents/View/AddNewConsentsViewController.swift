//
//  ConsentsViewController.swift
//  Growth99
//
//  Created by nitin auti on 05/02/23.
//

import Foundation
import UIKit

protocol AddNewConsentsViewControllerProtocol: AnyObject {
    func ConsentsListRecived()
    func errorReceived(error: String)
}

class AddNewConsentsViewController: UIViewController, AddNewConsentsViewControllerProtocol {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: AddNewConsentsViewModelProtocol?
    var filteredTableData = [AddNewConsentsModel]()
    var isSearch : Bool = false
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AddNewConsentsViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.view.ShowSpinner()
        viewModel?.getConsentsList()
        self.registerTableView()
        self.title = Constant.Profile.AssignConsent
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "ConsentsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ConsentsTableViewCell")
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "UserCreateViewController", bundle: nil).instantiateViewController(withIdentifier: "UserCreateViewController") as! UserCreateViewController
        self.present(createUserVC, animated: true)
    }
    
    func ConsentsListRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    @IBAction func SendtoPatientButtonTapped(_ sender: UIButton) {
        self.view.ShowSpinner()
        /// api is accepting wrong formate data
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension AddNewConsentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filteredTableData.count
        }else {
            return viewModel?.ConsentsDataList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ConsentsTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "ConsentsTableViewCell", for: indexPath) as! ConsentsTableViewCell
        if isSearch {
            cell.configureCell(consentsVM: viewModel, index: indexPath)
        } else {
            cell.configureCell(consentsVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let FillConsentsVC = UIStoryboard(name: "FillAddNewConsentsViewController", bundle: nil).instantiateViewController(withIdentifier: "FillAddNewConsentsViewController") as! FillAddNewConsentsViewController
        //  let consentsVM = viewModel?.ConsentsDataAtIndex(index: indexPath.row)
        //  FillConsentsVC.questionnaireId = consentsVM?.questionnaireId ?? 0
        //  FillConsentsVC.pateintId = pateintId
        //   self.navigationController?.pushViewController(FillConsentsVC, animated: true)
    }
}

extension AddNewConsentsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.ConsentsDataList.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
