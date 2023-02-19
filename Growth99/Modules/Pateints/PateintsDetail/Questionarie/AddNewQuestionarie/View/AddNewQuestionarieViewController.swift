//
//  AddNewQuestionarieViewController.swift
//  Growth99
//
//  Created by nitin auti on 24/01/23.
//

import Foundation
import UIKit

protocol AddNewQuestionarieViewControllerProtocol: AnyObject {
    func questionarieListRecived()
    func errorReceived(error: String)
}

class AddNewQuestionarieViewController: UIViewController,AddNewQuestionarieViewControllerProtocol {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: AddNewQuestionarieViewModelProtocol?
    var filteredTableData = [AddNewQuestionarieModel]()
    var isSearch : Bool = false
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.viewModel = AddNewQuestionarieViewModel(delegate: self)
        viewModel?.getQuestionarieList()
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "AddNewQuestionarieTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewQuestionarieTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.Questionnarie
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func questionarieListRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    @IBAction func SendtoPatientButtonTapped(_ sender: UIButton) {
        self.view.ShowSpinner()
        /// api is accepting wrong formate data
    }
}

extension AddNewQuestionarieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filteredTableData.count
        } else {
            return viewModel?.QuestionarieDataList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = AddNewQuestionarieTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "AddNewQuestionarieTableViewCell", for: indexPath) as! AddNewQuestionarieTableViewCell
        if isSearch {
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(questionarieVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension AddNewQuestionarieViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.QuestionarieDataList.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        tableView.reloadData()
    }
}


