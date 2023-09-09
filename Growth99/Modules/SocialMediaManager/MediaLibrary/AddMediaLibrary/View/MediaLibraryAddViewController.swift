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
    func mediaLibraryDetailsRecived()
    func saveMediaTagList(responseMessage:String)
    func errorReceived(error: String)
}

class MediaLibraryAddViewController: UIViewController {
    
    @IBOutlet weak var mediaLibraryTextField: CustomTextField!
    @IBOutlet weak var mediaLibraryLBI: UILabel!
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var browseImagButtonHight: NSLayoutConstraint!
    @IBOutlet weak var browseImageButton: UIButton!
    @IBOutlet weak var deleteBackroundImageButton: UIButton!
    
    var viewModel: MediaLibraryAddViewModelProtocol?
    var mediaTagId = Int()
    var mediaTagScreenName = String()
    var imageName = String()
    
    var selectedPostLabels = [Int]()
    var selectedTagList: [MediaTagListModel]?
    
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
            self.mediaLibraryLBI.text = "Edit Image"
            self.title = Constant.Profile.editMediaLibrary
        }else{
            self.mediaLibraryLBI.text = "Add Image"
            self.title = Constant.Profile.createMediaLibrary
            self.deleteBackroundImageButton.isHidden = true
        }
    }
    
    func setUPUI(){
        let item = viewModel?.getSocialMediaInfoDtails
        let libraryTag = (item?.socialTags ?? []).map({$0.libraryTag}).map({$0?.name})
        self.selectedTagList = (item?.socialTags ?? []).map({$0.libraryTag!}).map({$0})
        
        self.selectedPostLabels = (item?.socialTags ?? []).map({$0.libraryTag!}).map({$0.id ?? 0})
        
        self.mediaLibraryTextField.text = (libraryTag.map({$0 ?? ""})).joined(separator: ", ")
        self.mediaImage.sd_setImage(with: URL(string: item?.location ?? ""), placeholderImage: UIImage(named: "growthCircleIcon"), context: nil)
        self.mediaImage.isHidden = false
        self.deleteBackroundImageButton.isHidden = false
        self.browseImageButton.isHidden = true
        self.browseImagButtonHight.constant = 210
    }
    
    @IBAction func deleteBackroundImage(sender: UIButton){
        self.deleteBackroundImageButton.isHidden = true
        self.browseImageButton.isHidden = false
        self.browseImagButtonHight.constant = 20
        self.mediaImage.image = nil
    }
    
    @IBAction func openSocialMediaTagList(sender: UIButton){
        let rolesArray = viewModel?.getSocialMediaTagListData ?? []
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList.name
        }
        
        selectionMenu.setSelectedItems(items: selectedTagList ?? []) { [weak self] (text, index, selected, selectedList) in
            self?.mediaLibraryTextField.text  = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedPostLabels = selectedList.map({$0.id ?? 0})
            self?.selectedTagList = selectedList
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
            self.mediaLibraryTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let image = mediaImage.image else {
            return
        }
        self.view.ShowSpinner()
        let tagIds = selectedPostLabels.map { String($0) }.joined(separator: ",")
        var url = String()
        var methodType = String()
        var message = String()
        
        if  self.mediaTagScreenName == "Edit Screen" {
            url = ApiUrl.socialMediaLibrary.appending("/\(mediaTagId)")
            message = "Social media post updated successfully"
            methodType = "PUT"
        }else{
            url = ApiUrl.socialMediaLibrary
            methodType = "POST"
            message = "Social media library created successfully"
        }
        
        
        let urlParameter: Parameters = [
            "tags": tagIds,
        ]
        
        let request = ImageUplodManager(uploadImage: image, parameters: urlParameter, url: URL(string: url)!, method: methodType, name: "file", fileName: imageName)
        
        request.uploadImage { (result) in
            DispatchQueue.main.async {
                self.view.HideSpinner()
                switch result {
                case .success(let value):
                    print(value)
                    self.view.showToast(message: message, color: UIColor().successMessageColor())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension MediaLibraryAddViewController : MediaLibraryAddViewControllerProtocol{
    
    func socialMediaTagListRecived() {
        self.view.HideSpinner()
        if mediaTagScreenName == "Edit Screen" {
            self.view.ShowSpinner()
            self.viewModel?.getMediaLibraryDetails(mediaTagId: mediaTagId)
        }
    }
    
    func mediaLibraryDetailsRecived(){
        self.view.HideSpinner()
        self.setUPUI()
    }
    
    func saveMediaTagList(responseMessage:String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}
