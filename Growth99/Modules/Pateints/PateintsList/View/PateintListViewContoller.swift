//
//  PateintListViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation
import UIKit

protocol PateintListViewContollerProtocol: AnyObject {
    func LeadDataRecived()
    func pateintRemovedSuccefully(mrssage: String)
    func errorReceived(error: String)
}

class PateintListViewContoller: UIViewController {
    
    @IBOutlet weak var pateintListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var viewModel: PateintListViewModelProtocol?
    var isSearch : Bool = false
    var pateintFilterData = [PateintListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.pateint
        self.viewModel = PateintListViewModel(delegate: self)
        self.setBarButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.getPateintList()
        self.registerTableView()
    }
    
    func registerTableView() {
        self.pateintListTableView.delegate = self
        self.pateintListTableView.dataSource = self
        self.pateintListTableView.register(UINib(nibName: "PateintListTableViewCell", bundle: nil), forCellReuseIdentifier: "PateintListTableViewCell")
    }
    
    func setBarButton(){
        self.navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatUser), imageName: "add")
    }
    
    @objc func updateUI(){
        self.getPateintList()
        self.view.ShowSpinner()
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
        self.getPateintList()
    }

    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "CreatePateintViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintViewContoller") as! CreatePateintViewContoller
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }

    @objc func getPateintList() {
        self.view.ShowSpinner()
        self.viewModel?.getPateintList()
    }
}

extension PateintListViewContoller: PateintListViewContollerProtocol {
   
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.pateintListTableView.reloadData()
    }
    
    func pateintRemovedSuccefully(mrssage: String){
        viewModel?.getPateintList()
        self.view.showToast(message: mrssage, color: .black)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
}

extension PateintListViewContoller: PateintListTableViewCellDelegate {
   
    func editPatieint(cell: PateintListTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "PateintEditViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintEditViewController") as! PateintEditViewController
        editVC.pateintId = viewModel?.pateintDataAtIndex(index: index.row)?.id ?? 0
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func detailPatieint(cell: PateintListTableViewCell, index: IndexPath) {
        let PeteintDetail = PeteintDetailView.viewController()
        PeteintDetail.workflowTaskPatientId = viewModel?.pateintDataAtIndex(index: index.row)?.id ?? 0
        PeteintDetail.pateintsEmail = viewModel?.pateintDataAtIndex(index: index.row)?.email ?? ""
        self.navigationController?.pushViewController(PeteintDetail, animated: true)
    }
    
    func removePatieint(cell: PateintListTableViewCell, index: IndexPath) {
        let alert = UIAlertController(title: "Delete Patient", message: "Are you sure you want to delete \n\(viewModel?.pateintDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            let pateintId = self?.viewModel?.pateintDataAtIndex(index: index.row)?.id ?? 0
            self?.viewModel?.removePateints(pateintId: pateintId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
