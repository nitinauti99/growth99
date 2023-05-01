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
        
        guard let image = mediaImage.image, image != nil else {
            return
        }
        self.view.ShowSpinner()
        guard let image = self.mediaImage.image else { return  }
        let boundary = UUID().uuidString
        let tagIds = selectedPostLabels.map { String($0) }.joined(separator: ",")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
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
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.addValue(UserRepository.shared.Xtenantid ?? String.blank, forHTTPHeaderField: "x-tenantid")
        urlRequest.addValue("Bearer " + (UserRepository.shared.authToken ?? String.blank), forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = methodType
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"tags\"\r\n\r\n \(tagIds)".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(self.imageName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("uploaded to: \(responseString)")
                DispatchQueue.main.async {
                    self.view.HideSpinner()
                    self.view.showToast(message: message, color: UIColor().successMessageColor())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }).resume()
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
