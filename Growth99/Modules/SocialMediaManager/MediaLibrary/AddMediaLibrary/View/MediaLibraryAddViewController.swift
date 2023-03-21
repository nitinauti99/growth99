//
//  CreateMediaLibraryViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 21/03/23.
//

import Foundation
import UIKit

protocol MediaLibraryAddViewControllerProtocol: AnyObject {
    func socialMediaTagListRecived()
    func errorReceived(error: String)
    func saveMediaTagList(responseMessage:String)
}

class MediaLibraryAddViewController: UIViewController {
    
    @IBOutlet weak var mediaLibraryTextField: CustomTextField!
    @IBOutlet weak var mediaLibraryLBI: UILabel!
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var browseImagButtonHight: NSLayoutConstraint!
    
    var viewModel: MediaLibraryAddViewModelProtocol?
    var mediaTagId = Int()
    var mediaTagScreenName = String()
    var selectedPostLabels = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MediaLibraryAddViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.browseImagButtonHight.constant = 20
        self.view.ShowSpinner()
        self.viewModel?.getSocialMediaTagList()
        
        if self.mediaTagScreenName == "Edit Screen" {
            self.view.ShowSpinner()
            self.viewModel?.getMediaLibraryDetails(mediaTagId: mediaTagId)
            self.mediaLibraryLBI.text = "Edit Image"
            self.title = Constant.Profile.editMediaLibrary
            self.mediaLibraryTextField.text = viewModel?.mediaMediaLibraryDetailsData?.name ?? String.blank
        }else{
            self.mediaLibraryLBI.text = "Add Image"
            self.title = Constant.Profile.createMediaLibrary
        }
    }
    
    @IBAction func openSocialMediaTagList(sender: UIButton){
        let rolesArray = viewModel?.getSocialMediaTagListData ?? []
       
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList.name
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            self?.mediaLibraryTextField.text  = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedPostLabels = selectedList.map({$0.id ?? 0})
         }
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
  
    @objc func SendtoPatientButtonTapped(_ sender: UIButton) {
        self.view.ShowSpinner()
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton) {
        if let textField = mediaLibraryTextField.text,  textField == "" {
            self.mediaLibraryTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
        }
        self.view.ShowSpinner()
        if self.mediaTagScreenName == "Edit Screen" {
            self.viewModel?.saveMediaLibraryDetails(mediaTagId: mediaTagId, name: mediaLibraryTextField.text ?? String.blank)
        }else{
            let imageStringData = convertImageToBase64(image: mediaImage.image!)
            print("get base64 image string", imageStringData)
            
            self.view.ShowSpinner()
            viewModel?.createMediaLibraryDetails(tageId: self.selectedPostLabels, imageData: imageStringData)
        }
    }
    
    func convertImageToBase64(image: UIImage) -> String {
          let imageData = image.pngData()!
          return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
      }
    
}

extension MediaLibraryAddViewController : MediaLibraryAddViewControllerProtocol{
   
    func socialMediaTagListRecived() {
        self.view.HideSpinner()
        if mediaTagScreenName == "Edit Screen" {
            self.mediaLibraryTextField.text = viewModel?.mediaMediaLibraryDetailsData?.name ?? String.blank
        }
    }
    
    func saveMediaTagList(responseMessage:String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: .black)
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
}
