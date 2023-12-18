//
//  TwoWayTemplatesViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 17/12/23.
//

import UIKit

protocol TwoWayTemplateListViewContollerProtocol: AnyObject {
    func twoWayTemplateListDataRecived()
    func errorReceived(error: String)
}

class TwoWayTemplatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TwoWayTemplateListViewContollerProtocol {
    
    @IBOutlet weak var popUpview: UIView!
    @IBOutlet weak var tableViewTemplate: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: TwoWayTemplateViewModelProtocol?
    var sourceTypeTemplate: String = ""
    var soureFromTemplate: String = ""
    var sourceIdTemplate: Int = 0
    var selectedIndexPath: IndexPath?
    var isSearch : Bool = false
    var dismissCallback: DismissCallback?
    var selectedData: String?
    
    typealias DismissCallback = (String) -> Void
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        viewModel?.getTwoWayTemplateList(sourceType: sourceTypeTemplate, soureFrom: soureFromTemplate, sourceId: sourceIdTemplate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewCellRegister()
        self.popUpview.addBottomShadow(color: .gray, redius: 10, opacity: 0.5)
        self.viewModel = TwoWayTemplateListViewModel(delegate: self)
        
        closeButton.layer.cornerRadius = 24
        closeButton.clipsToBounds = true
        closeButton.layer.borderColor = UIColor(hexString: "#2656c9").cgColor
        closeButton.layer.borderWidth = 2.0
        addSerchBar()
    }
    
    func tableViewCellRegister() {
        tableViewTemplate.register(UINib(nibName: "TwoWayTemplatesTableViewCell", bundle: nil), forCellReuseIdentifier: "TwoWayTemplatesTableViewCell")
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = Constant.Profile.searchList
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func twoWayTemplateListDataRecived() {
        self.view.HideSpinner()
        self.tableViewTemplate.setContentOffset(.zero, animated: true)
        clearSearchBar()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func clearSearchBar() {
        isSearch = false
        searchBar.text = ""
        tableViewTemplate.reloadData()
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func dismissViewControllerWithData(data: String) {
        dismissCallback?(data)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getTwoWayTemplateData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TwoWayTemplatesTableViewCell()
        cell = tableViewTemplate.dequeueReusableCell(withIdentifier: "TwoWayTemplatesTableViewCell") as! TwoWayTemplatesTableViewCell
        cell.nameLbl.text = viewModel?.getTwoWayTemplateData[indexPath.row].name ?? ""
        cell.bodyLbl.text = viewModel?.getTwoWayTemplateData[indexPath.row].body ?? ""
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TwoWayTemplatesTableViewCell {
            cell.layer.borderColor = UIColor(hexString: "#2656c9").cgColor
            cell.layer.borderWidth = 2.0
            if isSearch {
                selectedData = viewModel?.getTwoWayTemplateFilterData[indexPath.row].body ?? ""
            } else {
                selectedData = viewModel?.getTwoWayTemplateData[indexPath.row].body ?? ""
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismissViewControllerWithData(data: self.selectedData ?? "")
            }
        }
    }
}

extension TwoWayTemplatesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getTwoWayTemplateFilterData(searchText: searchText)
        isSearch = true
        tableViewTemplate.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        tableViewTemplate.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
