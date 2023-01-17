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

    var viewModel: BusinessProfileViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        viewModel = BusinessProfileViewModel(delegate: self)
        nameTextField.text = "Admin"
    }
    
    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = "Business Profile"
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    func saveBusinessDetailReceived(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage)
    }
    
    @IBAction func imageIconbtnTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        businessImageView.image  = selectedImage
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
}
