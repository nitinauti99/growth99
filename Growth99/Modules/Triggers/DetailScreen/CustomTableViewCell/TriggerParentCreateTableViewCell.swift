//
//  TriggerParentCreateTableViewCell.swift
//  Growth99
//
//  Created by Exaze Technologies on 01/04/23.
//

import UIKit

protocol TriggerParentLeadCellDelegate: AnyObject {
    func smsTargetButton(cell: TriggerParentCreateTableViewCell, index: IndexPath, sender: UIButton)
    func smsNetworkButton(cell: TriggerParentCreateTableViewCell, index: IndexPath)
    func emailTargetButton(cell: TriggerParentCreateTableViewCell, index: IndexPath)
    func emailNetworkButton(cell: TriggerParentCreateTableViewCell, index: IndexPath)
    func taskNetworkNetworkButton(cell: TriggerTimeTableViewCell, index: IndexPath)
    func hourlyNetworkButton(cell: TriggerTimeTableViewCell, index: IndexPath)
    func scheduledBasedOnButton(cell: TriggerTimeTableViewCell, index: IndexPath)
}

class TriggerParentCreateTableViewCell: UITableViewCell {

    @IBOutlet weak var parentTableView: UITableView!

    var trigerData: [TriggerEditData] = []
    var moduleSelectionTypeTrigger: String = ""
    weak var delegate: TriggerParentLeadCellDelegate?
    var indexPath = IndexPath()
    var moduleSelectionEditTrigger: String = ""
    var selectedNetworkEditTrigger: String = ""
    var viewModel: TriggerEditDetailViewModelProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerTableView()
    }
    
    func configureCell(triggerEditData: [TriggerEditData]?, index: IndexPath, moduleSelectionTypeTrigger: String, selectedNetworkType: String, parentViewModel: TriggerEditDetailViewModelProtocol?) {
        indexPath = index
        moduleSelectionEditTrigger = moduleSelectionTypeTrigger
        selectedNetworkEditTrigger = selectedNetworkType
        trigerData = triggerEditData ?? []
        viewModel = parentViewModel
        parentTableView.reloadData()
    }
    
    func registerTableView() {
        self.parentTableView.delegate = self
        self.parentTableView.dataSource = self
        self.parentTableView.register(UINib(nibName: "TriggerSMSCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerSMSCreateTableViewCell")
        self.parentTableView.register(UINib(nibName: "TriggerTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerTimeTableViewCell")
    }
    
}

extension TriggerParentCreateTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trigerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerSMSCreateTableViewCell", for: indexPath) as? TriggerSMSCreateTableViewCell else { return UITableViewCell()}
            cell.networkSMSTagetSelectonButton.tag = indexPath.row
            cell.networkSMSTagetSelectonButton.addTarget(self, action: #selector(smsTargetSelectionMethod), for: .touchDown)
            cell.networkSMSNetworkSelectonButton.tag = indexPath.row
            cell.networkSMSNetworkSelectonButton.addTarget(self, action: #selector(smsNetworkSelectionMethod), for: .touchDown)
            
            cell.networkEmailTagetSelectonButton.tag = indexPath.row
            cell.networkEmailTagetSelectonButton.addTarget(self, action: #selector(emailTargetSelectionMethod), for: .touchDown)
            cell.networkEmailNetworkSelectonButton.tag = indexPath.row
            cell.networkEmailNetworkSelectonButton.addTarget(self, action: #selector(emailNetworkSelectionMethod), for: .touchDown)
            
            if moduleSelectionEditTrigger == "lead" {
                cell.taskBtn.isHidden = false
                cell.taskLabel.isHidden = false
                cell.assignTaskNetworkSelectonButton.tag = indexPath.row
                cell.assignTaskNetworkSelectonButton.addTarget(self, action: #selector(taskNetworkSelectionMethod), for: .touchDown)
            } else {
                cell.taskBtn.isHidden = true
                cell.taskLabel.isHidden = true
            }
            
            selectedNetworkEditTrigger = cell.networkTypeSelected
            if trigerData[indexPath.row].triggerType == "SMS" {
                cell.smsBtn.isSelected = true
                cell.emailBtn.isSelected = false
                cell.taskBtn.isSelected = false
                
                cell.selectSMSTargetTextLabel.text = trigerData[indexPath.row].triggerTarget
                let selectSMSNetworkName = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.id == trigerData[indexPath.row].triggerTemplate ?? 0} ) ?? []
                if selectSMSNetworkName.count > 0 {
                    cell.selectSMSNetworkTextLabel.text = selectSMSNetworkName[0].name ?? String.blank
                } else {
                    cell.selectSMSNetworkTextLabel.text = ""
                }
            } else if trigerData[indexPath.row].triggerType == "EMAIL" {
                cell.smsBtn.isSelected = false
                cell.emailBtn.isSelected = true
                cell.taskBtn.isSelected = false
                
                cell.selectEmailTargetTextLabel.text = trigerData[indexPath.row].triggerType
                let selectEmailNetworkName = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.id == trigerData[indexPath.row].triggerTemplate ?? 0} ) ?? []
                cell.selectEmailNetworkTextLabel.text = selectEmailNetworkName[0].name ?? String.blank
            } else {
                cell.smsBtn.isSelected = false
                cell.emailBtn.isSelected = false
                cell.taskBtn.isSelected = true
            }
            return cell
        } else {
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func smsTargetSelectionMethod(sender: UIButton) {
        self.delegate?.smsTargetButton(cell: self, index: indexPath, sender: sender)
    }
}
