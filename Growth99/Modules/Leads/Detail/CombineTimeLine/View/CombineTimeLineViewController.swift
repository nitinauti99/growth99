//
//  CombineTimeLineViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation
import UIKit

protocol CombineTimeLineViewControllerProtocol: AnyObject {
    func errorReceived(error: String)
    func recivedLeadCreation()
    func recivedAuditLeadList()
    func recivedLeadTimeLineTemplateData()
}

class CombineTimeLineViewController: UIViewController,
                                     CombineTimeLineViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CombineTimeLineViewModelProtocol?
    var leadId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CombineTimeLineViewModel(delegate: self)
        tableView.register(UINib(nibName: "LeadCombineTimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadCombineTimeLineTableViewCell")
       
        tableView.register(UINib(nibName: "LeadCreationCombineTimeLineTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "LeadCreationCombineTimeLineTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.Timeline
        self.view.ShowSpinner()
        viewModel?.getLeadTimeData(leadId: leadId)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func recivedLeadCreation() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func recivedAuditLeadList() {
        self.view.HideSpinner()
        self.viewModel?.leadCreation(leadId: leadId)
    }
}

extension CombineTimeLineViewController: LeadCombineTimeLineTableViewCellProtocol {
    func viewTemplate(cell: LeadCombineTimeLineTableViewCell, index: IndexPath, templateId: Int) {
        self.view.ShowSpinner()
        viewModel?.getTimeLineTemplateData(leadId: templateId)
    }
   
    func recivedLeadTimeLineTemplateData(){
        self.view.HideSpinner()
        let PateintsViewTemplateVC = PateintsViewTemplateController()
        PateintsViewTemplateVC.htmlString  = viewModel?.getLeadTimeLineViewTemplateData?.leadAuditContent
        PateintsViewTemplateVC.modalPresentationStyle = .overFullScreen
        self.present(PateintsViewTemplateVC, animated: true)
    }
    
}
