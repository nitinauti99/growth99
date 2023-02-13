//
//  FormListViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 13/02/23.
//

import Foundation
import UIKit

protocol FormListViewControllerProtocol {
    func FormsDataRecived()
    func errorReceived(error: String)
    func consentsRemovedSuccefully(mrssage: String)
}

class FormListViewController: UIViewController, FormListViewControllerProtocol, FormListTableViewCellDelegate {
    
    @IBOutlet var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: FormListViewModelProtocol?
    
    var workflowTaskPatientId = Int()
    var selectedindex = 0
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.FormsList
        viewModel = FormListViewModel(delegate: self)
        self.addSerchBar()
        self.view.ShowSpinner()
        viewModel?.getFormList()
        tableView.register(UINib(nibName: "FormListTableViewCell", bundle: nil), forCellReuseIdentifier: "FormListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func removePatieint(cell: FormListTableViewCell, index: IndexPath) {
        var consentsName : String = ""
        var consentsId = Int()
            consentsName = viewModel?.FormDataAtIndex(index: index.row)?.name ?? ""
            consentsId = viewModel?.FormDataAtIndex(index: index.row)?.id ?? 0
        if isSearch {
            consentsName = viewModel?.FormFilterDataAtIndex(index: index.row)?.name ?? ""
            consentsId =  viewModel?.FormFilterDataAtIndex(index: index.row)?.id ?? 0
        }
        
        let alert = UIAlertController(title: Constant.Profile.deleteConcents , message: "Are you sure you want to delete \n\(consentsName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeConsents(consentsId: consentsId)
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
        viewModel?.getFormList()
    }
    
    func consentsRemovedSuccefully(mrssage: String) {
        self.view.showToast(message: mrssage,color: .red)
        viewModel?.getFormList()
    }
        
    func FormsDataRecived(){
        self.view.HideSpinner()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
     }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
}
