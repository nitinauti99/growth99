//
//  QuestionnaireSubmissionsViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 08/03/23.
//

import Foundation
import UIKit

protocol QuestionnaireSubmissionsControllerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class QuestionnaireSubmissionsViewController: UIViewController, QuestionnaireSubmissionsControllerProtocol {
    
    @IBOutlet weak var questionarieListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: QuestionnaireSubmissionsViewModelModelProtocol?
    var isSearch : Bool = false
    var questionnaireId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = QuestionnaireSubmissionsViewModelModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationQuestionarieList"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        viewModel?.getQuestionarieList(pateintId: questionnaireId)
        self.registerTableView()
        self.title = Constant.Profile.users
    }
    
    @objc func updateUI(){
        self.view.ShowSpinner()
        viewModel?.getQuestionarieList(pateintId: questionnaireId)
    }
    
    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getQuestionarieList()
    }
    
    func registerTableView() {
        self.questionarieListTableView.delegate = self
        self.questionarieListTableView.dataSource = self
        self.questionarieListTableView.register(UINib(nibName: "QuestionnaireSubmissionsTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionnaireSubmissionsTableViewCell")
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "UserCreateViewController", bundle: nil).instantiateViewController(withIdentifier: "UserCreateViewController") as! UserCreateViewController
        self.present(createUserVC, animated: true)
    }
    
    @objc func getQuestionarieList(){
        self.view.ShowSpinner()
        viewModel?.getQuestionarieList(pateintId: questionnaireId)
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
