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
    
    @IBOutlet weak var questionarieListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        searchBar.placeholder = "Search..."
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
        if viewModel?.getQuestionarieDataList.count == 0 {
            self.emptyMessage(parentView: self.view, message: "There is no data to show")
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
