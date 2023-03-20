//
//  CreatePostViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 20/03/23.
//

import Foundation
import UIKit

protocol CreatePostViewControllerProtocol: AnyObject {
    func socialMediaPostLabelsListRecived()
    func socialProfilesListRecived()
    func errorReceived(error: String)
    func taskUserCreatedSuccessfully(responseMessage: String)
}

class CreatePostViewController: UIViewController {
    
    @IBOutlet private weak var hashtagTextField: CustomTextField!
    @IBOutlet private weak var labelTextField: CustomTextField!
    @IBOutlet private weak var scheduleDateTextField: CustomTextField!
    @IBOutlet private weak var scheduleTimeTextField: CustomTextField!
    @IBOutlet private weak var socialChannelTextField: CustomTextField!
    @IBOutlet private weak var PostTextView: UITextView!
    @IBOutlet private weak var upLoadImageButton: UIButton!
    @IBOutlet private weak var selectFromLibButton: UIButton!

    var viewModel: CreatePostViewModelProtocol?
    var dateFormater: DateFormaterProtocol?
    var postId = Int()
    var selectedPostLabels = [Int]()
    var selectedSocialProfiles = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreatePostViewModel(delegate: self)
        self.dateFormater = DateFormater()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getSocialMediaPostLabelsList()
    }

    @IBAction func cancelButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func uploadImageButton(sender: UIButton) {
        
    }
    
    @IBAction func uploadImageFromLibButton(sender: UIButton) {
        
    }
    
    @IBAction func createTaskUser(sender: UIButton) {
        
        if let hashtagTextField = self.hashtagTextField.text,  hashtagTextField == "" {
            return
        }
        
        if let labelTextField = self.labelTextField.text,  labelTextField == "" {
            return
        }
        
        if let scheduleDateTextField = self.scheduleDateTextField.text,  scheduleDateTextField == "" {
            return
        }
        
        if let scheduleTimeTextField = self.scheduleTimeTextField.text,  scheduleTimeTextField == "" {
            return
        }
        
        if let socialChannelTextField = self.socialChannelTextField.text,  socialChannelTextField == "" {
            return
        }
        
        self.view.ShowSpinner()
//        viewModel?.createPost(name: nameTextField.text ?? String.blank, description: descriptionTextView.text ?? String.blank, workflowTaskStatus: statusTextField.text ?? String.blank, workflowTaskUser: workflowTaskUser, deadline: serverToLocalInputWorking(date: DeadlineTextField.text ?? String.blank), workflowTaskPatient: workflowTaskPatient, questionnaireSubmissionId: questionnaireSubmissionId, leadOrPatient: leadOrPatientSelected)
    }
    
}

extension CreatePostViewController: CreatePostViewControllerProtocol {
  
    func socialMediaPostLabelsListRecived(){
        self.viewModel?.getsocialProfilesList()
    }
    
    func socialProfilesListRecived(){
        self.view.HideSpinner()
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func taskUserCreatedSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: .black)
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreatePostViewController {
   
    @IBAction func openLabelListDropDwon(sender: UIButton) {
        let rolesArray = viewModel?.getSocialMediaPostLabelsListData ?? []
       
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList.name
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            self?.labelTextField.text  = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedPostLabels = selectedList.map({$0.id ?? 0})
         }
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func openSocialChanelListDropDwon(sender: UIButton) {
        let rolesArray = viewModel?.getsocialProfilesListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList.name
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            self?.socialChannelTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedSocialProfiles = selectedList.map({$0.id ?? 0})
        }
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
}
