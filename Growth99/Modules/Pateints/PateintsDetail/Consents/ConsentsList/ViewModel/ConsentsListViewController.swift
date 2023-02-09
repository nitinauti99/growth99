//
//  ConsentsListViewController.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import Foundation
import UIKit

protocol ConsentsListViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class ConsentsListViewController: UIViewController, ConsentsListViewControllerProtocol {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: ConsentsListViewModelProtocol?
    var filteredTableData = [ConsentsListModel]()
    var isSearch : Bool = false
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSerchBar()
        self.registerTableView()
        self.viewModel = ConsentsListViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("ConsentsList"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        viewModel?.getConsentsList(pateintId: pateintId)
        self.title = Constant.Profile.users
    }
    
    @objc func updateUI(){
        self.view.ShowSpinner()
        viewModel?.getConsentsList(pateintId: pateintId)
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
        self.getConsentsList()
    }
    func getListFromServer(_ pageNumber: Int){
        self.view.ShowSpinner()
        viewModel?.getConsentsList(pateintId: pateintId)
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "ConsentsListTableViewCell", bundle: nil), forCellReuseIdentifier: "ConsentsListTableViewCell")
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "UserCreateViewController", bundle: nil).instantiateViewController(withIdentifier: "UserCreateViewController") as! UserCreateViewController
        self.present(createUserVC, animated: true)
    }
    
    @objc func getConsentsList(){
        self.view.ShowSpinner()
        viewModel?.getConsentsList(pateintId: pateintId)
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension ConsentsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filteredTableData.count
        } else {
            return viewModel?.consentsDataList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ConsentsListTableViewCell()
        cell = self.tableView.dequeueReusableCell(withIdentifier: "ConsentsListTableViewCell") as! ConsentsListTableViewCell
        if isSearch {
            cell.configureCell(consentsVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(consentsVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let FillQuestionarieVC = UIStoryboard(name: "FillQuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "FillQuestionarieViewController") as! FillQuestionarieViewController
        //        let questionarieVM = viewModel?.QuestionarieDataAtIndex(index: indexPath.row)
        //        FillQuestionarieVC.questionnaireId = questionarieVM?.questionnaireId ?? 0
        //        FillQuestionarieVC.pateintId = pateintId
        //        self.navigationController?.pushViewController(FillQuestionarieVC, animated: true)
    }
}

extension ConsentsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.consentsDataList.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
