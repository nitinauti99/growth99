//
//  BusinessProfileViewController.swift
//  Growth99
//
//  Created by admin on 27/12/22.
//

import UIKit

protocol BusinessProfileViewControllerProtocol {
    func errorReceived(error: String)
    func saveBusinessDetailReceived(responseMessage: String)
}

class BusinessProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, BusinessProfileViewControllerProtocol {
   
    @IBOutlet private weak var nameTextField: CustomTextField!
    @IBOutlet private weak var businessImageView: UIImageView!
    @IBOutlet private weak var businessNoteImageView: UIImageView!

    var viewModel: BusinessProfileViewModelProtocol?
    var bussinessInfoData: BusinessSubDomainModel?
    let user = UserRepository.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        viewModel = BusinessProfileViewModel(delegate: self)
        nameTextField.text = bussinessInfoData?.name
        businessImageView.sd_setImage(with: URL(string: bussinessInfoData?.logoUrl ?? String.blank), placeholderImage: UIImage(named: "Logo.png"))
        businessNoteImageView.image = UIImage.fontAwesomeIcon(code: "fa-exclamation-triangle", style: .solid, textColor: UIColor.black, size: CGSize(width: 15, height: 15))
    }
    
    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.businessProfile
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func saveBusinessDetailReceived(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: .black)
    }
    
    @IBAction func imageIconbtnTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        businessImageView.image  = selectedImage
        viewModel?.uploadSelectedImage(image: selectedImage)
        self.dismiss(animated: true, completion: nil)
    }
    
   /* func uploadImage(selectedImage: UIImage) {
        let boundary = UUID().uuidString
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var urlRequest = URLRequest(url: URL(string: "https://api.growthemr.com/api/businesses/1413/logo")!)
        urlRequest.addValue("Bearer "+(UserRepository.shared.authToken ?? String.blank), forHTTPHeaderField: "Authorization")
        urlRequest.addValue(UserRepository.shared.Xtenantid ?? String.blank, forHTTPHeaderField: "x-tenantid")
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\("blob")\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(selectedImage.pngData()!)
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
            }
        }).resume()
    }*/

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ssavebtnTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else {
            nameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        self.view.ShowSpinner()
        viewModel?.saveBusinessInfo(name: name, trainingBusiness: false)
    }
}
