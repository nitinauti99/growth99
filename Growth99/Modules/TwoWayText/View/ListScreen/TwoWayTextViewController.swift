//
//  TwoWayTextViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 04/12/23.
//

import UIKit

struct TowWayTextListModel {
    var auditLogsList: AuditLogsList?
    
}


class TwoWayTextViewController: UIViewController, TwoWayListViewContollerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var templateButton: UIButton!

    var twoWayListData : [AuditLogs]?
    var filteredArray: [AuditLogsList]?
    var finalArray : [FilterList] = []
    var finalArrayList : [FilterListArray] = []
    var receiverNumber = String()

    var sourceType : String = ""
    var sourceName : String = ""
    var sourceTemplateType : String = ""
    var phoneNumber : String = ""
    var sourceTypeId : Int = 0
    var selectedSection : Int = 0
    var isFirstTime: Bool = false
    
    var viewModel: TwoWayListViewModelProtocol?
    let user = UserRepository.shared
    var dateFormater : DateFormaterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = TwoWayListViewModel(delegate: self)
        tableView.dataSource = self
        tableView.delegate = self
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
        tableView.register(UINib(nibName: "NumberChangeTableViewCell", bundle: nil), forCellReuseIdentifier: "NumberChangeTableViewCell")

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
        var changedNumberArray = [AuditLogs]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        for item in twoWayListData ?? [] {
            if item.direction == "outgoing" {
                if receiverNumber.isEmpty {
                    receiverNumber = item.receiverNumber ?? ""
                }
                if receiverNumber == item.receiverNumber {
                    receiverNumber = item.receiverNumber ?? ""
                }else{
                    receiverNumber = item.receiverNumber ?? ""
                    let auditLogs = AuditLogs(id: item.id, sourceId: item.sourceId, sourceType: item.sourceType, sourceName: item.sourceName, businessId: item.businessId, senderNumber: item.senderNumber, receiverNumber: item.receiverNumber, forwardedNumber: item.forwardedNumber, direction: item.direction, message: item.message, createdDateTime: item.createdDateTime, isNumberChanged: true, smsRead: item.smsRead, deliverStatus: item.deliverStatus, errorMessage: item.errorMessage)
                    changedNumberArray.append(auditLogs)
                }
                changedNumberArray.append(item)
            }else{
                changedNumberArray.append(item)
            }
        }
        print("receiverNumber array", changedNumberArray)
        
        let sortedListData = changedNumberArray.sorted {
            $0.createdDateTime ?? "" < $1.createdDateTime ?? ""
           }
           
        let finalDict = Dictionary(grouping: sortedListData , by: { $0.createdDate })
        
        for item in finalDict {
            finalArrayList.append(FilterListArray(createdDate: item.key , logs: item.value))
        }

        finalArrayList.sort {
            guard let date1 = dateFormatter.date(from: $0.createdDate),
                  let date2 = dateFormatter.date(from: $1.createdDate) else {
                return false
            }
            return date1 < date2

        }
        scrollToBottom()
        self.tableView.reloadData()
    }
    
    
    func twoWayDetailListDataRecived() {
        self.view.HideSpinner()
        finalArrayList = []
        receiverNumber = ""
        var changedNumberArray = [AuditLogs]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
     
        twoWayListData = viewModel?.twoWayCompleteListData.filter { $0.sourceId == sourceTypeId }.flatMap { $0.auditLogs ?? [] }
        
        for item in twoWayListData ?? [] {
            if item.direction == "outgoing" {
                if receiverNumber.isEmpty {
                    receiverNumber = item.receiverNumber ?? ""
                }
                if receiverNumber == item.receiverNumber {
                    receiverNumber = item.receiverNumber ?? ""
                }else{
                    receiverNumber = item.receiverNumber ?? ""
                    let auditLogs = AuditLogs(id: item.id, sourceId: item.sourceId, sourceType: item.sourceType, sourceName: item.sourceName, businessId: item.businessId, senderNumber: item.senderNumber, receiverNumber: item.receiverNumber, forwardedNumber: item.forwardedNumber, direction: item.direction, message: item.message, createdDateTime: item.createdDateTime, isNumberChanged: true, smsRead: item.smsRead, deliverStatus: item.deliverStatus, errorMessage: item.errorMessage)
                    changedNumberArray.append(auditLogs)
                }
                changedNumberArray.append(item)
            }else{
                changedNumberArray.append(item)
            }
        }
        
        let sortedListData = changedNumberArray.sorted {
            $0.createdDateTime ?? "" < $1.createdDateTime ?? ""
           }
      
        let finalDict = Dictionary(grouping: changedNumberArray, by: { $0.createdDate })
        for item in finalDict {
            finalArrayList.append(FilterListArray(createdDate: item.key , logs: item.value))
        }
        finalArrayList.sort {
            guard let date1 = dateFormatter.date(from: $0.createdDate),
                  let date2 = dateFormatter.date(from: $1.createdDate) else {
                return false
            }
            return date1 < date2

        }
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

extension TwoWayTextViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return finalArrayList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalArrayList[section].logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = finalArrayList[indexPath.section]
        
        if message.logs[indexPath.row].direction == "outgoing" {
            if message.logs[indexPath.row].isNumberChanged == true {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NumberChangeTableViewCell", for: indexPath) as! NumberChangeTableViewCell
                cell.label?.text = "Phone number changed from \(receiverNumber) to \(message.logs[indexPath.row].receiverNumber ?? "")"

                return cell
            }else{
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
                receiverNumber =  message.logs[indexPath.row].receiverNumber ?? ""
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.K.cellIdentifierReceiver, for: indexPath) as! MessageCellReceiver
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubbleLine.isHidden = true
            cell.labelTitle.text = "\(sourceName)  (\(message.logs[indexPath.row].senderNumber ?? ""))"
            cell.label.text = message.logs[indexPath.row].message ?? ""
            cell.messageBubble.backgroundColor = UIColor(hexString: "#dae2f4")
            cell.label.textColor = UIColor.black
            cell.labelTitle.textColor = UIColor.black
            cell.dateLabel.textColor = UIColor.black
            cell.dateLabel.text = dateFormater?.utcToLocal(timeString:  message.logs[indexPath.row].createdDateTime ?? "")
            receiverNumber = message.logs[indexPath.row].receiverNumber ?? ""
            isFirstTime = false
            
            return cell
        }
    }
    
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel()
            label.frame = CGRect.init(x: (headerView.frame.width/2) - 40, y: 5, width: 120, height: headerView.frame.height-10)
             label.layer.cornerRadius = 12
             label.clipsToBounds = true
            label.text = "   \(finalArrayList[section].createdDate)"
            label.backgroundColor = UIColor(hexString: "#dae2f4")
            label.font = .systemFont(ofSize: 16)
            label.textColor = UIColor(hexString: "#4b68c9")
            headerView.addSubview(label)
            return headerView
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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



