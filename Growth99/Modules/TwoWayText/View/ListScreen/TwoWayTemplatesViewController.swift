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
    @IBOutlet weak var selectButton: UIButton!
    var viewModel: TwoWayTemplateViewModelProtocol?
    
    var sourceTypeTemplate: String = ""
    var soureFromTemplate: String = ""
    var sourceIdTemplate: Int = 0
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewCellRegister()
        self.popUpview.addBottomShadow(color: .gray, redius: 10, opacity: 0.5)
        self.viewModel = TwoWayTemplateListViewModel(delegate: self)
        
        selectButton.layer.cornerRadius = 24
        selectButton.clipsToBounds = true
        selectButton.backgroundColor = UIColor(hexString: "#9FA3A9")
        
        closeButton.layer.cornerRadius = 24
        closeButton.clipsToBounds = true
        closeButton.layer.borderColor = UIColor(hexString: "#2656c9").cgColor
        closeButton.layer.borderWidth = 2.0
        self.view.ShowSpinner()
        viewModel?.getTwoWayTemplateList(sourceType: sourceTypeTemplate, soureFrom: soureFromTemplate, sourceId: sourceIdTemplate)
    }
    
    func tableViewCellRegister() {
        tableViewTemplate.register(UINib(nibName: "TwoWayTemplatesTableViewCell", bundle: nil), forCellReuseIdentifier: "TwoWayTemplatesTableViewCell")
    }
    
    func twoWayTemplateListDataRecived() {
        self.view.HideSpinner()
        self.tableViewTemplate.setContentOffset(.zero, animated: true)
        self.tableViewTemplate.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    @IBAction func templatesSelectPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true)
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
        selectButton.backgroundColor = UIColor(hexString: "#2656c9")
        if let cell = tableView.cellForRow(at: indexPath) as? TwoWayTemplatesTableViewCell {
            cell.layer.borderColor = UIColor(hexString: "#2656c9").cgColor
            cell.layer.borderWidth = 2.0
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectButton.backgroundColor = UIColor(hexString: "#9FA3A9")
        if let cell = tableView.cellForRow(at: indexPath) as? TwoWayTemplatesTableViewCell {
            cell.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
