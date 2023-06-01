//
//  BusinessProfileViewController.swift
//  Growth99
//
//  Created by admin on 27/12/22.
//

import UIKit

protocol BusinessProfileViewControllerProtocol {
    func errorReceived(error: String)
    func businessInformationReponse(responseMessage: String,
                                    businessName: String,
                                    businessLogoUrl: String)
}

class BusinessProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, BusinessProfileViewControllerProtocol, UITextFieldDelegate {
    
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
        user.bussinessLogo = bussinessInfoData?.logoUrl ?? String.blank
        businessNoteImageView.image = UIImage.fontAwesomeIcon(code: "fa-exclamation-triangle", style: .solid, textColor: UIColor.black, size: CGSize(width: 15, height: 15))
    }
    
    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.businessProfile
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func businessInformationReponse(responseMessage: String, businessName: String, businessLogoUrl: String) {
        self.view.HideSpinner()
        user.bussinessName = businessName
        user.bussinessLogo = businessLogoUrl
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
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
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == nameTextField {
            guard let textField = nameTextField.text, !textField.isEmpty else {
                nameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
                return
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField {
            guard let textField = nameTextField.text, !textField.isEmpty else {
                nameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
                return
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = Int()
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == nameTextField {
            maxLength = 30
            nameTextField.hideError()
            return newString.length <= maxLength
        }
        return true
    }
}
