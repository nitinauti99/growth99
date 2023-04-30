//
//  chatQuestionnaireViewContoller.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
import UIKit

protocol chatQuestionnaireViewContollerProtocol {
    func ConsentsTemplatesDataRecived()
    func errorReceived(error: String)
    func consentsRemovedSuccefully(mrssage: String)
}

class chatQuestionnaireViewContoller: UIViewController, chatQuestionnaireViewContollerProtocol,chatQuestionnaireTableViewCellDelegate {
    
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: chatQuestionnaireViewModelProtocol?
    
    var workflowTaskPatientId = Int()
    var selectedindex = 0
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.consentsTemplatesList
        self.viewModel = chatQuestionnaireViewModel(delegate: self)
        self.addSerchBar()
        self.tableView.register(UINib(nibName: "chatQuestionnaireTableViewCell", bundle: nil), forCellReuseIdentifier: "chatQuestionnaireTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getchatQuestionnaire()
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func removePatieint(cell: chatQuestionnaireTableViewCell, index: IndexPath) {
        var consentsName : String = ""
        var consentsId = Int()
            consentsName = viewModel?.chatQuestionnaireDataAtIndex(index: index.row)?.name ?? String.blank
            consentsId = viewModel?.chatQuestionnaireDataAtIndex(index: index.row)?.id ?? 0
        if isSearch {
            consentsName = viewModel?.chatQuestionnaireFilterDataAtIndex(index: index.row)?.name ?? String.blank
            consentsId =  viewModel?.chatQuestionnaireFilterDataAtIndex(index: index.row)?.id ?? 0
        }
        
        let alert = UIAlertController(title: "Delete Chat Questionnaires" , message: "Are you sure you want to delete \n\(consentsName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeChatQuestionnaire(chatQuestionnaireId: consentsId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "CreatePateintViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintViewContoller") as! CreatePateintViewContoller
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }
    
    @objc func getPateintList() {
        self.view.ShowSpinner()
        self.viewModel?.getchatQuestionnaire()
    }
    
    func consentsRemovedSuccefully(mrssage: String) {
        self.view.showToast(message: mrssage,color: .red)
        self.viewModel?.getchatQuestionnaire()
    }
        
    func ConsentsTemplatesDataRecived(){
        self.view.HideSpinner()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
     }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
}
