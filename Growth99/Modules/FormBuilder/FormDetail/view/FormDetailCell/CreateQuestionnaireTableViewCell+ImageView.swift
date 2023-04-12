//
//  CreateQuestionnaireTableViewCell+ImageView.swift
//  Growth99
//
//  Created by Nitin Auti on 11/04/23.
//

import Foundation

extension CreateQuestionnaireTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBAction func addBackroundImage(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.delegate?.presnetImagePickerController(cell: self, imagePicker: imagePickerController)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.backroundImage.image  = selectedImage
        self.editButton.isHidden = false
        self.deleteButton.isHidden = false
        backroundImageSelctionViewHight.constant = 220
        self.backroundImageHight.constant = 130
        self.backroundImageSelctionButton.isHidden = true
        self.delegate?.dismissImagePickerController(cell: self)
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.dismissImagePickerController(cell: self)
    }
    
    @IBAction func editBackroundImage(sender: UIButton){
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.delegate?.presnetImagePickerController(cell: self, imagePicker: imagePickerController)
    }
    
    @IBAction func deleteBackroundImage(sender: UIButton){
        self.backroundImage.image = nil
        self.backroundImageHight.constant = 0
        self.editButton.isHidden = true
        self.deleteButton.isHidden = true
        self.backroundImageSelctionLBI.isHidden = false
        self.backroundImageSelctionButton.isHidden = false
        self.backroundImageSelctionViewHight.constant = 90
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
}
