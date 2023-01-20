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
}

class PateintListViewContoller: UIViewController, PateintListViewContollerProtocol {

    @IBOutlet weak var pateintListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var viewModel: PateintListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [PateintListModel]()

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
        self.getUserList()
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
        self.getUserList()
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
        self.getUserList()
    }

    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "CreatePateintViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintViewContoller") as! CreatePateintViewContoller
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }
    
   @objc func editButtonTapped() {
        print("called edit action")
        let editVC = UIStoryboard(name: "PateintEditViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintEditViewController") as! PateintEditViewController
        self.navigationController?.pushViewController(editVC, animated: true)
    }

    @objc func getUserList(){
        self.view.ShowSpinner()
        viewModel?.getUserList()
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
