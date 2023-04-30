//
//  MediaTagsAddViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 21/03/23.
//

import Foundation
import UIKit

protocol MediaTagsAddViewControllerProtocol: AnyObject {
    func mediaTagListRecived()
    func errorReceived(error: String)
    func saveMediaTagList(responseMessage:String)
}

class MediaTagsAddViewController: UIViewController, MediaTagsAddViewControllerProtocol {
    
    @IBOutlet private weak var MediaTagsTextField: CustomTextField!
    @IBOutlet private weak var MediaTagsLBI: UILabel!
    
    var viewModel: MediaTagsAddViewModelProtocol?
    var mediaTagId = Int()
    var mediaTagScreenName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MediaTagsAddViewModel(delegate: self)
        if mediaTagScreenName == "Edit Screen" {
            self.view.ShowSpinner()
            viewModel?.getMediaTagsDetails(mediaTagId: mediaTagId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mediaTagScreenName == "Edit Screen" {
            self.MediaTagsLBI.text = "Edit Media Tag"
            self.title = "Edit Tag"
            self.MediaTagsTextField.text = viewModel?.mediaTagsDetailsData?.name ?? String.blank
        }else{
            self.MediaTagsLBI.text = "Create Media Tag"
            self.title = "Add Tag"
        }
    }
    
    func mediaTagListRecived() {
        self.view.HideSpinner()
        if mediaTagScreenName == "Edit Screen" {
            self.MediaTagsTextField.text = viewModel?.mediaTagsDetailsData?.name ?? String.blank
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    @objc func SendtoPatientButtonTapped(_ sender: UIButton) {
        self.view.ShowSpinner()
    }
    
    func saveMediaTagList(responseMessage:String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: .black)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        if let textField = MediaTagsTextField.text,  textField == "" {
            MediaTagsTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        self.view.ShowSpinner()
        if mediaTagScreenName == "Edit Screen" {
            viewModel?.saveMediaTagsDetails(mediaTagId: mediaTagId, name: MediaTagsTextField.text ?? String.blank)
        }else{
            viewModel?.createMediaTagsDetails(name: MediaTagsTextField.text ?? String.blank)
        }
    }
    
}
