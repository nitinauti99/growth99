//
//  AddNewQuestionarieViewController.swift
//  Growth99
//
//  Created by nitin auti on 24/01/23.
//

import Foundation
import UIKit

protocol AddNewQuestionarieViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class AddNewQuestionarieViewController: UIViewController, AddNewQuestionarieViewControllerProtocol {
    
    @IBOutlet private weak var AddNewQuestionarieTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: AddNewQuestionarieViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [AddNewQuestionarieModel]()
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AddNewQuestionarieViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationQuestionarieList"), object: nil)
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
        self.view.ShowSpinner()
        viewModel?.getQuestionarieList()
    }
    
    @objc func addUserButtonTapped(_ sender: UIButton) {
        let detailController = UIStoryboard(name: "UserCreateViewController", bundle: nil).instantiateViewController(withIdentifier: "UserCreateViewController") as! UserCreateViewController
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.registerTableView()
        self.title = Constant.Profile.users
    }
    
    @objc func updateUI(){
        self.view.ShowSpinner()
        viewModel?.getQuestionarieList()
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
        self.getQuestionarieList()
    }
    func getListFromServer(_ pageNumber: Int){
        self.view.ShowSpinner()
        viewModel?.getQuestionarieList()
    }

    func registerTableView() {
        self.AddNewQuestionarieTableView.delegate = self
        self.AddNewQuestionarieTableView.dataSource = self
        AddNewQuestionarieTableView.register(UINib(nibName: "AddNewQuestionarieTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewQuestionarieTableViewCell")
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "UserCreateViewController", bundle: nil).instantiateViewController(withIdentifier: "UserCreateViewController") as! UserCreateViewController
        self.present(createUserVC, animated: true)
    }
    
    @objc func getQuestionarieList(){
        self.view.ShowSpinner()
        viewModel?.getQuestionarieList()
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.AddNewQuestionarieTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
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
        cell = AddNewQuestionarieTableView.dequeueReusableCell(withIdentifier: "AddNewQuestionarieTableViewCell") as! AddNewQuestionarieTableViewCell
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let FillQuestionarieVC = UIStoryboard(name: "FillAddNewQuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "FillAddNewQuestionarieViewController") as! FillAddNewQuestionarieViewController
//        let questionarieVM = viewModel?.QuestionarieDataAtIndex(index: indexPath.row)
//        FillQuestionarieVC.questionnaireId = questionarieVM?.questionnaireId ?? 0
//        FillQuestionarieVC.pateintId = pateintId
//        self.navigationController?.pushViewController(FillQuestionarieVC, animated: true)
//    }
}

extension AddNewQuestionarieViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.QuestionarieDataList.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        AddNewQuestionarieTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        AddNewQuestionarieTableView.reloadData()
    }
    
}


