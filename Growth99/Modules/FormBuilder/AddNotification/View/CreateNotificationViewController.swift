//
//  CreateNotificationViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 26/02/23.
//

import Foundation
import UIKit

protocol CreateNotificationViewContollerProtocol {
    func errorReceived(error: String)
    func createdNotificationSuccessfully(message: String)
    func recivedNotificationData()
}

class CreateNotificationViewController: UIViewController, CreateNotificationViewContollerProtocol {
   
    @IBOutlet  weak var notificationTypeTextField: CustomTextField!
    @IBOutlet  weak var selectedNotificationTypeTextField: CustomTextField!
    @IBOutlet private weak var notificationTypeLBI: UILabel!
    @IBOutlet private weak var saveButton: UIButton!

    var viewModel: CreateNotificationViewModelProtocol?
    var categoryName: String = String.blank
    var questionId = Int()
    var notificationId = Int()
    var screenName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateNotificationViewModel(delegate: self)
        self.saveButton.isUserInteractionEnabled = false
        self.title = Constant.Profile.creatNotification
        if screenName == "Edit Notification" {
            self.title = "Edit Notification"
            self.view.ShowSpinner()
            self.viewModel?.getCreateCreateNotification(questionId: questionId, notificationId: notificationId)
        }
        self.selectedNotificationTypeTextField.addTarget(self, action:
                                                #selector(self.textFieldDidChange(_:)),
                                                         for: .editingChanged)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
    }
    
    @IBAction func notificationTypeDropDown(sender: UIButton) {
        let notificationArray = ["EMAIL", "SMS"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: notificationArray, cellType: .subTitle) { (cell, list, indexPath) in
            cell.textLabel?.text = list
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.selectedNotificationTypeTextField.text = ""
            if selectedItem == "EMAIL" {
                self?.notificationTypeLBI.text = "To"
            }else{
                self?.notificationTypeLBI.text = "Phone Number"
            }
            self?.saveButton.isUserInteractionEnabled = true
            self?.notificationTypeTextField.text  = selectedItem
            selectionMenu.dismissAutomatically = true
        }
        selectionMenu.reloadInputViews()
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(notificationArray.count * 44))), arrowDirection: .up), from: self)
     }
    
    func addCategoriesResponse() {
        self.view.HideSpinner()
        self.view.showToast(message: Constant.Profile.addCategorie, color: UIColor().successMessageColor())
        self.navigationController?.popViewController(animated: true)
    }
    
    func recivedNotificationData() {
        self.view.HideSpinner()
        let data = viewModel?.getgetNotificationData
        self.notificationTypeTextField.text = data?.notificationType
        self.saveButton.isUserInteractionEnabled = true
        if data?.notificationType == "EMAIL" {
            self.selectedNotificationTypeTextField.text = data?.toEmail
            self.notificationTypeLBI.text = "To"
        }else{
            self.selectedNotificationTypeTextField.text = data?.phoneNumber
            self.notificationTypeLBI.text = "Phone Number"
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func createdNotificationSuccessfully(message: String) {
        self.view.HideSpinner()
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveButtonAction(sender: UIButton) {
        var params: [String : Any] = [:]

        if self.notificationTypeTextField.text == "SMS" {
            guard let phoneNumber = selectedNotificationTypeTextField.text, !phoneNumber.isEmpty else {
                selectedNotificationTypeTextField.showError(message: "Phone Number is required")
                return
            }

            // Remove non-digit characters using regular expression
            let cleanedPhoneNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            guard cleanedPhoneNumber.count >= 10 else {
                selectedNotificationTypeTextField.showError(message: "Phone Number should contain 10 digits")
                return
            }
            
            if let textField  = selectedNotificationTypeTextField.text, let phoneNumber = viewModel?.isValidPhoneNumber(textField), phoneNumber == false {
                selectedNotificationTypeTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
                return
            }
            
            params = [
               "notificationType": "SMS",
               "toEmail": "",
               "messageText": "",
               "phoneNumber": selectedNotificationTypeTextField.text ?? String.blank,
           ]
        }else {
            guard let emailText = selectedNotificationTypeTextField.text, !emailText.isEmpty else {
                selectedNotificationTypeTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
                return
            }
            if let textField  = selectedNotificationTypeTextField.text, let emailValidate = viewModel?.isValidEmail(textField), emailValidate == false {
                selectedNotificationTypeTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
                return
            }
            params = [
               "notificationType": "EMAIL",
               "phoneNumber": "",
               "messageText": "",
               "toEmail" : selectedNotificationTypeTextField.text ?? String.blank,
           ]
        }
        if screenName == "Edit Notification" {
            self.view.ShowSpinner()
            viewModel?.updateNotification(questionId: questionId, notificationId: notificationId, params: params)
        }else {
            self.view.ShowSpinner()
            viewModel?.createNotification(questionId: questionId,params: params)
        }
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateNotificationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.notificationTypeTextField.text == "SMS" {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
        }
        return true
    }
   
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.notificationTypeTextField.text == "SMS" {
            guard let phoneNumber  = selectedNotificationTypeTextField.text, !phoneNumber.isEmpty else {
                selectedNotificationTypeTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
                return
            }
            
            guard let phoneNumber  = selectedNotificationTypeTextField.text, let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNumber), phoneNumberValidate else {
                selectedNotificationTypeTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
                return
            }
        }else{
            guard let emailText = selectedNotificationTypeTextField.text, !emailText.isEmpty else {
                selectedNotificationTypeTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
                return
            }
            guard let emailText = selectedNotificationTypeTextField.text, let emailValidate = viewModel?.isValidEmail(emailText), emailValidate else {
                selectedNotificationTypeTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
                return
            }
        }
    }
}
