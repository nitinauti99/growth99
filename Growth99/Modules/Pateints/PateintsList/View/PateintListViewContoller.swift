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
    func errorReceived(error: String)
    func pateintRemovedSuccefully(mrssage: String)
}

class PateintListViewContoller: UIViewController, PateintListViewContollerProtocol, PateintListTableViewCellDelegate {
    
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
        addSerchBar()
        self.getPateintList()
        self.registerTableView()
    }
    
    func registerTableView() {
        self.pateintListTableView.delegate = self
        self.pateintListTableView.dataSource = self
        pateintListTableView.register(UINib(nibName: "PateintListTableViewCell", bundle: nil), forCellReuseIdentifier: "PateintListTableViewCell")
    }
    
    func setBarButton(){
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "add"), for: .normal)
        button.addTarget(self, action:  #selector(creatUser), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func updateUI(){
        self.getPateintList()
        self.view.ShowSpinner()
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
        self.getPateintList()
    }

    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "CreatePateintViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintViewContoller") as! CreatePateintViewContoller
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }
    
    func removePatieint(cell: PateintListTableViewCell, index: IndexPath) {
        let alert = UIAlertController(title: "Delete Patient", message: "Are you sure you want to delete \(viewModel?.PateintDataAtIndex(index: index.row)?.name ?? "")", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            self?.view.ShowSpinner()
            let pateintId = self?.viewModel?.PateintDataAtIndex(index: index.row)?.id ?? 0
            self?.viewModel?.removePateints(pateintId: pateintId)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func getPateintList() {
        self.view.ShowSpinner()
        viewModel?.getPateintList()
    }
    
    func pateintRemovedSuccefully(mrssage: String){
        viewModel?.getPateintList()
    }

    func editPatieint(cell: PateintListTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "PateintEditViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintEditViewController") as! PateintEditViewController
        editVC.pateintId = viewModel?.PateintDataAtIndex(index: index.row)?.id ?? 0
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func detailPatieint(cell: PateintListTableViewCell, index: IndexPath) {
//        let detailController = UIStoryboard(name: "PateintDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintDetailViewController") as! PateintDetailViewController
//        detailController.workflowTaskPatientId = viewModel?.PateintDataAtIndex(index: index.row)?.id ?? 0
//        self.navigationController?.pushViewController(detailController, animated: true)
        
        let PeteintDetail = PeteintDetailView.viewController()
        PeteintDetail.workflowTaskPatientId = viewModel?.PateintDataAtIndex(index: index.row)?.id ?? 0
        self.navigationController?.pushViewController(PeteintDetail, animated: true)
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.pateintListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}