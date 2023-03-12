//
//  UnansweredQuestionListViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation
import UIKit

protocol UnansweredQuestionListViewControllerProtocol: AnyObject {
    func unansweredQuestionListRecived()
    func errorReceived(error: String)
}

class UnansweredQuestionListViewController: UIViewController {
    @IBOutlet weak var questionnaireName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: UnansweredQuestionListViewModelProtocol?
   
    var isSearch: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
        self.title = Constant.Profile.unansweredQuestionList
        self.viewModel = UnansweredQuestionListViewModel(delegate: self)
        self.view.ShowSpinner()
        self.viewModel?.getUnansweredQuestionList()
    }

    func registerTableView() {
        self.tableView.register(UINib(nibName: "UnansweredQuestionListTableViewCell", bundle: nil), forCellReuseIdentifier: "UnansweredQuestionListTableViewCell")
    }
}

extension UnansweredQuestionListViewController: UnansweredQuestionListViewControllerProtocol{
    
    func unansweredQuestionListRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
}
