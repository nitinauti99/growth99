//
//  CreatePostViewController+UIImagePickerController.swift
//  Growth99
//
//  Created by Nitin Auti on 25/03/23.
//

import Foundation

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    @IBAction func uploadImageButton(sender: UIButton){
        if sender.titleLabel?.text == "Remove" {
            self.postImageView.image  = nil
            self.postImageView.isHidden = true
            self.postImageViewButtonHight.constant = 20
            self.upLoadImageButton.setTitle("Upload Image", for: .normal)
            self.selectFromLibButton.isHidden = false

        }else{
            self.postImageView.image  = nil
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false //If you want edit option set "true"
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            present(imagePickerController, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.postImageView.image  = selectedImage
        self.postImageView.isHidden = false
        self.postImageViewButtonHight.constant = 150
        self.upLoadImageButton.setTitle("Remove", for: .normal)
        self.selectFromLibButton.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editBackroundImage(sender: UIButton){
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(imagePickerController, animated: true, completion: nil)
    }

    
}
