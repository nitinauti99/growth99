//
//  QuestionarieViewController.swift
//  Growth99
//
//  Created by nitin auti on 21/01/23.
//

import Foundation
import UIKit

protocol QuestionarieViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class QuestionarieViewController: UIViewController, QuestionarieViewControllerProtocol {
    
    @IBOutlet private weak var questionarieListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: QuestionarieViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [QuestionarieModel]()
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = QuestionarieViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationQuestionarieList"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.view.ShowSpinner()
        viewModel?.getQuestionarieList(pateintId: pateintId)
        self.registerTableView()
        self.title = Constant.Profile.users
    }
    
    @objc func updateUI(){
        self.view.ShowSpinner()
        viewModel?.getQuestionarieList(pateintId: pateintId)
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
        viewModel?.getQuestionarieList(pateintId: pateintId)
    }

    func registerTableView() {
        self.questionarieListTableView.delegate = self
        self.questionarieListTableView.dataSource = self
        self.questionarieListTableView.register(UINib(nibName: "QuestionarieTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionarieTableViewCell")
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "UserCreateViewController", bundle: nil).instantiateViewController(withIdentifier: "UserCreateViewController") as! UserCreateViewController
        self.present(createUserVC, animated: true)
    }
    
    @objc func getQuestionarieList(){
        self.view.ShowSpinner()
        viewModel?.getQuestionarieList(pateintId: pateintId)
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.questionarieListTableView.reloadData()
        if viewModel?.QuestionarieDataList.count == 0 {
           self.emptyMessage(parentView: self.view, message: "There is no data")
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension QuestionarieViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        var cell = QuestionarieTableViewCell()
        cell = questionarieListTableView.dequeueReusableCell(withIdentifier: "QuestionarieTableViewCell") as! QuestionarieTableViewCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let FillQuestionarieVC = UIStoryboard(name: "FillQuestionarieViewController", bundle: nil).instantiateViewController(withIdentifier: "FillQuestionarieViewController") as! FillQuestionarieViewController
        let questionarieVM = viewModel?.QuestionarieDataAtIndex(index: indexPath.row)
        FillQuestionarieVC.questionnaireId = questionarieVM?.questionnaireId ?? 0
        FillQuestionarieVC.pateintId = pateintId
        self.navigationController?.pushViewController(FillQuestionarieVC, animated: true)
    }
}

extension QuestionarieViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.QuestionarieDataList.filter { $0.questionnaireName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        questionarieListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        questionarieListTableView.reloadData()
    }
}
