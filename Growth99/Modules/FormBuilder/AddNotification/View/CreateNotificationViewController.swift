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
   
    @IBOutlet private weak var notificationTypeTextField: CustomTextField!
    @IBOutlet private weak var selectedNotificationTypeTextField: CustomTextField!
    @IBOutlet private weak var notificationTypeLBI: UILabel!

    var viewModel: CreateNotificationViewModelProtocol?
    var categoryName: String = String.blank
    var questionId = Int()
    var notificationId = Int()
    var screenName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CreateNotificationViewModel(delegate: self)
        if screenName == "Edit Notification" {
            self.view.ShowSpinner()
           viewModel?.getCreateCreateNotification(questionId: questionId, notificationId: notificationId)
        }
        self.selectedNotificationTypeTextField.addTarget(self, action:
                                                #selector(self.textFieldDidChange(_:)),
                                                         for: .editingChanged)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.creatNotification
    }
    
    @IBAction func notificationTypeDropDown(sender: UIButton) {
        let notificationArray = ["EMAIL", "SMS"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: notificationArray, cellType: .subTitle) { (cell, list, indexPath) in
            cell.textLabel?.text = list.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.selectedNotificationTypeTextField.text = ""
            if selectedItem == "EMAIL" {
                self?.notificationTypeLBI.text = "To"
            }else{
                self?.notificationTypeLBI.text = "Phone Number"
            }
            self?.notificationTypeTextField.text  = selectedItem
            selectionMenu.dismissAutomatically = true
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(notificationArray.count * 44))), arrowDirection: .up), from: self)
     }
    
    func addCategoriesResponse() {
        self.view.HideSpinner()
        self.view.showToast(message: Constant.Profile.addCategorie, color: .black)
        self.navigationController?.popViewController(animated: true)
    }
    
    func recivedNotificationData() {
        self.view.HideSpinner()
        let data = viewModel?.getgetNotificationData
        self.notificationTypeTextField.text = data?.notificationType
        if data?.notificationType == "EMAIL" {
            self.selectedNotificationTypeTextField.text = data?.toEmail
        }else{
            self.selectedNotificationTypeTextField.text = data?.phoneNumber
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func createdNotificationSuccessfully(message: String) {
        self.view.HideSpinner()
        self.view.showToast(message: message, color: .black)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(sender: UIButton) {
        var params: [String : Any] = [:]

        if self.notificationTypeTextField.text == "SMS" {
            if let textField  = selectedNotificationTypeTextField.text, let phoneNumberValidate = viewModel?.isValidPhoneNumber(textField), phoneNumberValidate == false {
                selectedNotificationTypeTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
            }
            params = [
               "notificationType": "SMS",
               "phoneNumber": selectedNotificationTypeTextField.text ?? String.blank,
           ]
        }else{
            if let textField  = selectedNotificationTypeTextField.text, let emailValidate = viewModel?.isValidEmail(textField), emailValidate == false {
                selectedNotificationTypeTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
            }
            params = [
               "notificationType": "EMAIL",
               "toEmail" : selectedNotificationTypeTextField.text ?? String.blank,
           ]
        }

        self.view.ShowSpinner()
        viewModel?.createNotification(questionId: questionId, notificationId: notificationId, params: params)
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateNotificationViewController: UITextFieldDelegate {
   
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.notificationTypeTextField.text == "SMS" {
            if let textField  = selectedNotificationTypeTextField.text, let phoneNumberValidate = viewModel?.isValidPhoneNumber(textField), phoneNumberValidate == false {
                selectedNotificationTypeTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
            }
        }else{
            if let textField  = selectedNotificationTypeTextField.text, let emailValidate = viewModel?.isValidEmail(textField), emailValidate == false {
                selectedNotificationTypeTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
            }
        }
    }
}
