//
//  leadDetailViewController.swift
//  Growth99
//
//  Created by nitin auti on 03/12/22.
//

import UIKit

protocol leadDetailViewControllerProtocol: AnyObject {
    func errorReceived(error: String)
    func recivedQuestionnaireList()
    func recivedSmsTemplateList()
    func recivedEmailTemplateList()
    func updatedLeadStatusRecived(responseMessage: String)
    func smsSendSuccessfully(responseMessage: String)
    func emailSendSuccessfully(responseMessage: String)
}

class leadDetailViewController: UIViewController,questionAnswersTableViewCellDelegate {
   
    @IBOutlet private weak var symptoms: UILabel!
    @IBOutlet private weak var gender: UILabel!
    @IBOutlet private weak var message: UILabel!
    @IBOutlet private weak var phoneNumber: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var lastName: UILabel!
    @IBOutlet private weak var firstName: UILabel!
    @IBOutlet private weak var source: UILabel!
    @IBOutlet private weak var sourceURL: UILabel!
    @IBOutlet private weak var landingPage: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet weak var scrollViewHight: NSLayoutConstraint!
    @IBOutlet weak var anslistTableView: UITableView!
    @IBOutlet private weak var newButton: UIButton!
    @IBOutlet private weak var coldButton: UIButton!
    @IBOutlet private weak var warmButton: UIButton!
    @IBOutlet private weak var hotButton: UIButton!
    @IBOutlet private weak var wonButton: UIButton!
    @IBOutlet private weak var deadButton: UIButton!
    @IBOutlet private weak var fullName: UILabel!

    var buttons: [UIButton] = []
    var patientQuestionList = [QuestionAnswers]()
    var viewModel: leadDetailViewProtocol?
    var leadData: leadListModel?
    
    var leadId: Int?
    var selctedSmsTemplateId = Int()
    let user = UserRepository.shared

    var tableViewHeight: CGFloat {
        anslistTableView.layoutIfNeeded()
        return anslistTableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.title = "Lead Detail"
        self.viewModel = leadDetailViewModel(delegate: self)
        self.buttons = [newButton, coldButton, warmButton, hotButton, wonButton, deadButton]
    }
   
    func registerCell() {
        anslistTableView.register(UINib(nibName: "questionAnswersTableViewCell", bundle: nil), forCellReuseIdentifier: "questionAnswersTableViewCell")
        anslistTableView.register(UINib(nibName: "LeadSMSTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadSMSTemplateTableViewCell")
        anslistTableView.register(UINib(nibName: "LeadCustomSMSTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadCustomSMSTemplateTableViewCell")
        anslistTableView.register(UINib(nibName: "LeadEmailTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadEmailTemplateTableViewCell")
        anslistTableView.register(UINib(nibName: "LeadCustomEmailTemplateTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadCustomEmailTemplateTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        leadId = user.leadId
        self.fullName.text = user.leadFullName
        self.viewModel?.getQuestionnaireList(questionnaireId: leadId ?? 0)
        newButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        coldButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        warmButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        hotButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        wonButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
        deadButton.addTarget(self, action: #selector(self.leadStatusTemplate(_:)), for:.touchUpInside)
    }
    
    @objc func leadStatusTemplate(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        print(sender.titleLabel?.text ?? String.blank)
        let str = sender.titleLabel?.text ?? String.blank
        self.view.ShowSpinner()
        viewModel?.updateLeadStatus(template: "\(leadId ?? 0)/status/\(str.uppercased())")
    }

    func setLeadStatus(status: String) {
        if status == "NEW" {
            newButton.isSelected = true
        }else if (status == "WARM" ) {
            warmButton.isSelected = true
        }else if (status == "COLD" ) {
            coldButton.isSelected = true
        }else if (status == "HOT" ) {
            hotButton.isSelected = true
        }else if (status == "WON" ) {
            wonButton.isSelected = true
        }else if (status == "DEAD" ) {
            deadButton.isSelected = true
        }
    }
    
    func editButtonPressed(cell: questionAnswersTableViewCell) {
        let editLeadVC = UIStoryboard(name: "EditLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "EditLeadViewController") as! EditLeadViewController
        editLeadVC.LeadData = leadData
        self.navigationController?.pushViewController(editLeadVC, animated: true)
    }
    
}

extension leadDetailViewController: leadDetailViewControllerProtocol {

    func smsSendSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        self.anslistTableView.reloadData()
        self.view.ShowSpinner()
        self.viewModel?.getQuestionnaireList(questionnaireId: leadId ?? 0)
    }
    
    func updatedLeadStatusRecived(responseMessage: String) {
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        self.viewModel?.getQuestionnaireList(questionnaireId: leadId ?? 0)
    }
    
    func emailSendSuccessfully(responseMessage: String)  {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        self.view.ShowSpinner()
        self.anslistTableView.reloadData()
        self.viewModel?.getQuestionnaireList(questionnaireId: leadId ?? 0)
    }
    
    func recivedEmailTemplateList(){
        self.view.HideSpinner()
    }
    
    func recivedSmsTemplateList(){
        self.viewModel?.getEmailDefaultList()
    }
    
    func recivedQuestionnaireList() {
        self.anslistTableView.reloadData()
        self.scrollViewHight.constant = tableViewHeight + 500
        self.view.setNeedsLayout()
        self.setLeadStatus(status: viewModel?.leadStatus ?? String.blank)
        self.viewModel?.getSMSDefaultList()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}
