//
//  TwoWayTextViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 04/12/23.
//

import UIKit


class TwoWayTextViewController: UIViewController, TwoWayListViewContollerProtocol {
    func twoWayListDataRecived() {
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @objc func dismissKeyboard() {
        messageTextfield.endEditing(true)
    }
    
    var twoWayListData : [AuditLogs]?
    var filteredArray: [AuditLogsList]?
    
    var sourceType : String = ""
    var phoneNumber : String = ""
    var sourceTypeId : Int = 0
    var viewModel: TwoWayListViewModelProtocol?
    
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
        self.tableView.setContentOffset(.zero, animated: true)
        scrollToBottom()
        self.tableView.reloadData()
    }
    
    func twoWayDetailDataRecived() {
        self.view.HideSpinner()
        messageTextfield.text = ""
        self.view.ShowSpinner()
        viewModel?.getTwoWayList(pageNo: 0, pageSize: 15, fromPage: "Detail")
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
        twoWayTemplateVC.modalPresentationStyle = .overFullScreen
        twoWayTemplateVC.sourceTypeTemplate = "Appointment"
        twoWayTemplateVC.soureFromTemplate = "lead"
        twoWayTemplateVC.sourceIdTemplate = 138281
        self.present(twoWayTemplateVC, animated: true)
    }
}

extension TwoWayTextViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twoWayListData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = twoWayListData?[indexPath.row].message ?? ""
        return cell
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
            let indexPath = IndexPath(row: (self.twoWayListData?.count ?? 0) - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
