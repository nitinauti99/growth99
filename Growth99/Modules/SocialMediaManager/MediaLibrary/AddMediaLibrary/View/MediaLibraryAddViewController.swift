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
    
    let boundary: String = "------WebKitFormBoundarytgue2M7DLZIlgYY2"

    
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
            guard let image = self.mediaImage.image else { return  }
            
//            viewModel?.createMediaLibraryDetails(tageId:  self.selectedPostLabels, image: image)

            
            let filename = "avatar.png"
            let boundary = UUID().uuidString
            let fieldName = "tags"
            let tagIds = selectedPostLabels.map { String($0) }.joined(separator: ",")

            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)

            var urlRequest = URLRequest(url: URL(string: "https://api.growthemr.com/api/socialMedia/library")!)
            urlRequest.addValue(UserRepository.shared.Xtenantid ?? String.blank, forHTTPHeaderField: "x-tenantid")
            urlRequest.addValue("Bearer "+(UserRepository.shared.authToken ?? String.blank), forHTTPHeaderField: "Authorization")
            urlRequest.httpMethod = "POST"

            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var data = Data()
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"tags\"\r\n\r\n \(tagIds)".data(using: .utf8)!)

            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
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
                    self.view.HideSpinner()
                }
            }).resume()
       }
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

//extension Data {
//    
//    mutating func append(_ string: String) {
//        if let data = string.data(using: .utf8) {
//            self.append(data)
//        }
//    }
//}
