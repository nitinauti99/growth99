//
//  TwoWayTextViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 04/12/23.
//

import UIKit


class TwoWayTextViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @objc func dismissKeyboard() {
        messageTextfield.endEditing(true)
    }
    
    var twoWayListData : [AuditLogs]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        messageTextfield.delegate = self
        self.title = "Message Detail"
        
        messageTextfield.placeholder = "Type here..."
        messageTextfield.textColor = .black
        tableView.register(UINib(nibName: Constant.K.cellNibName, bundle: nil), forCellReuseIdentifier: Constant.K.cellIdentifier)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        scrollToBottom()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        messageTextfield.text = ""
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
        messageTextfield.text = ""
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
