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
    @IBOutlet weak var templateButton: UIButton!

    var twoWayListData : [AuditLogs]?
    var filteredArray: [AuditLogsList]?
    var finalArray : [FilterList] = []
    var finalArrayList : [FilterListArray] = []
    
    var sourceType : String = ""
    var sourceName : String = ""
    var sourceTemplateType : String = ""
    var phoneNumber : String = ""
    var sourceTypeId : Int = 0
    var selectedSection : Int = 0
    var receiverNumber : String = ""
    var isFirstTime: Bool = false
    
    var viewModel: TwoWayListViewModelProtocol?
    let user = UserRepository.shared
    var dateFormater : DateFormaterProtocol?
    
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
        dateFormater = DateFormater()
        tableView.register(UINib(nibName: Constant.K.cellNibName, bundle: nil), forCellReuseIdentifier: Constant.K.cellIdentifier)
        tableView.register(UINib(nibName: Constant.K.cellNibNameReceiver, bundle: nil), forCellReuseIdentifier: Constant.K.cellIdentifierReceiver)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpData()
        templateButton.isEnabled = true
        if self.sourceTypeId == 0 {
            templateButton.isEnabled = false
        }
    }
    
    func setUpData(){
        finalArrayList = []
        let finalDict = Dictionary(grouping: twoWayListData ?? [], by: { $0.createdDate })
        for item in finalDict {
            finalArrayList.append(FilterListArray(createdDate: item.key, logs: item.value))
        }
        finalArrayList.sort(by: {$0.createdDate < $1.createdDate})
        scrollToBottom()
        self.tableView.reloadData()
    }
    
    
    func twoWayDetailListDataRecived() {
        self.view.HideSpinner()
        finalArrayList = []
        twoWayListData = viewModel?.twoWayCompleteListData .filter { $0.sourceId == sourceTypeId }.flatMap { $0.auditLogs ?? [] }
        let finalDict = Dictionary(grouping: twoWayListData ?? [], by: { $0.createdDate })
        for item in finalDict {
            finalArrayList.append(FilterListArray(createdDate: item.key, logs: item.value))
        }
        finalArrayList.sort(by: {$0.createdDate < $1.createdDate})
        scrollToBottom()
        self.tableView.reloadData()
    }
    
    func twoWayDetailDataRecived() {
        self.messageTextfield.text = ""
        self.view.ShowSpinner()
        self.viewModel?.getTwoWayList(pageNo: 0, pageSize: 15, fromPage: "Detail")
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
        }else {
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
        if sourceTemplateType == "Patient" {
            sourceTemplateType = "Appointment"
        }
        twoWayTemplateVC.sourceTypeTemplate = sourceTemplateType
        twoWayTemplateVC.soureFromTemplate = "lead"
        twoWayTemplateVC.sourceIdTemplate = sourceTypeId
        self.present(twoWayTemplateVC, animated: true)
    }
    
    @objc func dismissKeyboard() {
        messageTextfield.endEditing(true)
    }
}

extension TwoWayTextViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return finalArrayList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalArrayList[section].logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = finalArrayList[indexPath.section]
        if receiverNumber.isEmpty {
            receiverNumber = message.logs[indexPath.row].receiverNumber ?? ""
            isFirstTime = true
        }
        if isFirstTime == false && receiverNumber ==  message.logs[indexPath.row].receiverNumber {
            print("receiverNumber changed")
            receiverNumber = message.logs[indexPath.row].receiverNumber ?? ""
            
            if message.logs[indexPath.row].direction == "outgoing" {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.K.cellIdentifier, for: indexPath) as! MessageCell
                cell.label.text = message.logs[indexPath.row].message ?? ""
                cell.labelTitle.text = "\(user.bussinessName ?? "")  (\(message.logs[indexPath.row].senderNumber ?? ""))"
                cell.messageBubble.backgroundColor = UIColor(hexString: "#2656C9")
                cell.leftImageView.isHidden = false
                cell.rightImageView.isHidden = true
                cell.messageBubbleLine.isHidden = false
                cell.dateLabel.textColor = UIColor.white
                cell.dateLabel.text = dateFormater?.utcToLocal(timeString:  message.logs[indexPath.row].createdDateTime ?? "")
                receiverNumber = message.logs[indexPath.row].receiverNumber ?? ""
                isFirstTime = false
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.K.cellIdentifierReceiver, for: indexPath) as! MessageCellReceiver
                cell.leftImageView.isHidden = true
                cell.rightImageView.isHidden = false
                cell.messageBubbleLine.isHidden = true
                cell.labelTitle.text = "\(sourceName)  (\(message.logs[indexPath.row].senderNumber ?? ""))"
                cell.label.text = message.logs[indexPath.row].message ?? ""
                cell.messageBubble.backgroundColor = UIColor(hexString: "##dae2f4")
                cell.label.textColor = UIColor.black
                cell.labelTitle.textColor = UIColor.black
                cell.dateLabel.textColor = UIColor.black
                cell.dateLabel.text = dateFormater?.utcToLocal(timeString:  message.logs[indexPath.row].createdDateTime ?? "")
                receiverNumber = message.logs[indexPath.row].receiverNumber ?? ""
                isFirstTime = false

                return cell
            }
        }else {
            if message.logs[indexPath.row].direction == "outgoing" {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.K.cellIdentifier, for: indexPath) as! MessageCell
                cell.label.text = message.logs[indexPath.row].message ?? ""
                cell.labelTitle.text = "\(user.bussinessName ?? "")  (\(message.logs[indexPath.row].senderNumber ?? ""))"
                cell.messageBubble.backgroundColor = UIColor(hexString: "#2656C9")
                cell.leftImageView.isHidden = false
                cell.rightImageView.isHidden = true
                cell.messageBubbleLine.isHidden = false
                cell.dateLabel.textColor = UIColor.white
                cell.dateLabel.text = dateFormater?.utcToLocal(timeString:  message.logs[indexPath.row].createdDateTime ?? "")
                receiverNumber = message.logs[indexPath.row].receiverNumber ?? ""
                isFirstTime = false
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.K.cellIdentifierReceiver, for: indexPath) as! MessageCellReceiver
                cell.leftImageView.isHidden = true
                cell.rightImageView.isHidden = false
                cell.messageBubbleLine.isHidden = true
                cell.labelTitle.text = "\(sourceName)  (\(message.logs[indexPath.row].senderNumber ?? ""))"
                cell.label.text = message.logs[indexPath.row].message ?? ""
                cell.messageBubble.backgroundColor = UIColor(hexString: "##dae2f4")
                cell.label.textColor = UIColor.black
                cell.labelTitle.textColor = UIColor.black
                cell.dateLabel.textColor = UIColor.black
                cell.dateLabel.text = dateFormater?.utcToLocal(timeString:  message.logs[indexPath.row].createdDateTime ?? "")
                receiverNumber = message.logs[indexPath.row].receiverNumber ?? ""
                isFirstTime = false

                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return finalArrayList[section].createdDate
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
            let sections = self.finalArrayList.count
            
            guard sections > 0 else {
                return
            }
            let section = sections - 1
            let rows = self.finalArrayList[section].logs.count
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

