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
        messageTextfield.textColor = .black
        tableView.register(UINib(nibName: Constant.K.cellNibName, bundle: nil), forCellReuseIdentifier: Constant.K.cellIdentifier)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        scrollToBottom()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        messageTextfield.resignFirstResponder();
        self.view.ShowSpinner()
        var urlParameter: Parameters = [String: Any]()
        if sourceType == "Lead" {
            urlParameter = ["body": messageTextfield.text ?? "", "phoneNumber": phoneNumber, "leadId": sourceTypeId]
        } else {
            urlParameter = ["body": messageTextfield.text ?? "", "phoneNumber": phoneNumber, "patientId": sourceTypeId]
        }
        viewModel?.sendMessage(msgData: urlParameter, sourceType: sourceType.lowercased())
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let newText = currentText.replacingCharacters(in: range, with: string) as NSString
        sendButton.isEnabled = newText.length > 1
        return true
    }
    
    func twoWayDetailDataRecived() {
        self.view.HideSpinner()
        messageTextfield.text = ""
        self.tableView.setContentOffset(.zero, animated: true)
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
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
}

extension TwoWayTextViewController {
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: (self.twoWayListData?.count ?? 0)-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
