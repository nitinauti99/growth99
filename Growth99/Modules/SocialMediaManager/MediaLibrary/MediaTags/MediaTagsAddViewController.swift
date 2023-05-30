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
    
    @IBOutlet weak var MediaTagsTextField: CustomTextField!
    @IBOutlet private weak var MediaTagsLBI: UILabel!
    
    var viewModel: MediaTagsAddViewModelProtocol?
    var mediaTagId = Int()
    var mediaTagScreenName = String()
    var mediaTagsList: [MediaTagListModel]?

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
            self.title = "Edit Media Tag"
            self.MediaTagsTextField.text = viewModel?.mediaTagsDetailsData?.name ?? String.blank
        }else{
            self.MediaTagsLBI.text = "Create Media Tag"
            self.title = "Create Media Tag"
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
        self.view.showToast(message: error, color: .red)
    }
    
    @objc func SendtoPatientButtonTapped(_ sender: UIButton) {
        self.view.ShowSpinner()
    }
    
    func saveMediaTagList(responseMessage:String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        if let textField = MediaTagsTextField.text,  textField == "" {
            MediaTagsTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        if mediaTagScreenName == "Edit Screen" {
            if let isValuePresent = self.mediaTagsList?.filter({ $0.name?.lowercased() == self.MediaTagsTextField.text}), isValuePresent.count > 0 {
                self.MediaTagsTextField.showError(message: "Tag with this name already present.")
                return
            }
            self.view.ShowSpinner()
            viewModel?.saveMediaTagsDetails(mediaTagId: mediaTagId, name: MediaTagsTextField.text ?? String.blank)
        }else{
            if let isValuePresent = self.mediaTagsList?.filter({ $0.name?.lowercased() == self.MediaTagsTextField.text}), isValuePresent.count > 0 {
                self.MediaTagsTextField.showError(message: "Tag with this name already present.")
                return
            }
            self.view.ShowSpinner()
            viewModel?.createMediaTagsDetails(name: MediaTagsTextField.text ?? String.blank)
        }
    }
    
}
