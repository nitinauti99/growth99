//
//  TwoWayTextViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 04/12/23.
//

import UIKit


class TwoWayTextViewController: UIViewController, TwoWayListViewContollerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var twoWayListData : [AuditLogs]?
    var filteredArray: [AuditLogsList]?
    
    var sourceType : String = ""
    var phoneNumber : String = ""
    var sourceTypeId : Int = 0
    var viewModel: TwoWayListViewModelProtocol?
    let user = UserRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = TwoWayListViewModel(delegate: self)
        tableView.dataSource = self
        messageTextfield.delegate = self
        self.title = "Message Detail"
        self.sendButton.layer.cornerRadius = 10
        self.sendButton.clipsToBounds = true
        messageTextfield.placeholder = "Type here..."
        sendButton.isEnabled = false
        sendButton.alpha = 0.5
        messageTextfield.textColor = .black
        tableView.register(UINib(nibName: Constant.K.cellNibName, bundle: nil), forCellReuseIdentifier: Constant.K.cellIdentifier)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        viewModel?.getTwoWayList(pageNo: 0, pageSize: 15, fromPage: "Detail")
    }
    
    func twoWayDetailListDataRecived() {
        self.view.HideSpinner()
        twoWayListData = viewModel?.getTwoWayData
            .filter { $0.sourceId == sourceTypeId }
            .flatMap { $0.auditLogs ?? [] }
        filteredArray = viewModel?.getTwoWayData
            .filter { $0.sourceId == sourceTypeId }
        scrollToBottom()
        self.tableView.reloadData()
    }
    
    func twoWayDetailDataRecived() {
        self.view.HideSpinner()
        messageTextfield.text = ""
        self.view.ShowSpinner()
        viewModel?.getTwoWayList(pageNo: 0, pageSize: 15, fromPage: "Detail")
    }
    
    func twoWayListDataRecived() {
        
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        messageTextfield.resignFirstResponder()
        guard let message = messageTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), !message.isEmpty else {
            sendButton.isEnabled = false
            sendButton.alpha = 0.5
            messageTextfield.text = ""
            return
        }
        self.view.ShowSpinner()
        var urlParameter: Parameters = [String: Any]()
        if sourceType == "Lead" {
            urlParameter = ["body": message, "phoneNumber": phoneNumber, "leadId": sourceTypeId]
        } else {
            urlParameter = ["body": message, "phoneNumber": phoneNumber, "patientId": sourceTypeId]
        }
        viewModel?.sendMessage(msgData: urlParameter, sourceType: sourceType.lowercased())
    }
    
    @IBAction func templatesPressed(_ sender: UIButton) {
        let twoWayTemplateVC = TwoWayTemplatesViewController()
        twoWayTemplateVC.dismissCallback = { [weak self] data in
            self?.messageTextfield.text = data
            self?.sendButton.isEnabled = true
            self?.sendButton.alpha = 1.0
        }
        twoWayTemplateVC.modalPresentationStyle = .overFullScreen
        twoWayTemplateVC.sourceTypeTemplate = "Lead"
        twoWayTemplateVC.soureFromTemplate = "lead"
        twoWayTemplateVC.sourceIdTemplate = 379895
        //        twoWayTemplateVC.sourceTypeTemplate = filteredArray?.first?.source ?? ""
        //        twoWayTemplateVC.soureFromTemplate = twoWayListData?.first?.sourceType ?? ""
        //        twoWayTemplateVC.sourceIdTemplate = filteredArray?.first?.sourceId ?? 0
        self.present(twoWayTemplateVC, animated: true)
    }
    
    @objc func dismissKeyboard() {
        messageTextfield.endEditing(true)
    }
}

extension TwoWayTextViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let filteredArray = filteredArray else {
            return 0
        }
        
        let groupedSections = Dictionary(grouping: filteredArray) { (element) -> String in
            if let logs = element.auditLogs, let firstLog = logs.first, let createdDateTime = firstLog.createdDateTime {
                return createdDateTime
            } else {
                return ""
            }
        }
        let sortedKeys = groupedSections.keys.sorted()
        return sortedKeys.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray?[section].auditLogs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = filteredArray?[indexPath.section].auditLogs?[indexPath.row].message ?? ""
        cell.labelTitle.text = user.bussinessName
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let firstLog = filteredArray?[section].auditLogs?.first else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: firstLog.createdDateTime ?? "") {
            let headerFormatter = DateFormatter()
            headerFormatter.dateFormat = "dd MMM yyyy"
            return headerFormatter.string(from: date)
        }
        return nil
    }
}

extension TwoWayTextViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        sendButton.isEnabled = !newText.isEmpty
        sendButton.alpha = newText.isEmpty ? 0.5 : 1.0
        return true
    }
}

extension TwoWayTextViewController {
    func scrollToBottom() {
        DispatchQueue.main.async {
            guard let sections = self.filteredArray?.count, sections > 0 else {
                return
            }
            
            let section = sections - 1
            let rows = self.filteredArray?[section].auditLogs?.count ?? 0
            
            guard rows > 0 else {
                return
            }
            
            let row = rows - 1
            let indexPath = IndexPath(row: row, section: section)
            
            if section < self.tableView.numberOfSections && row < self.tableView.numberOfRows(inSection: section) {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

