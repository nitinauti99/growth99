//
//  CreatePostViewController+UIImagePickerController.swift
//  Growth99
//
//  Created by Nitin Auti on 25/03/23.
//

import Foundation

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    @IBAction func uploadImageButton(sender: UIButton){
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.postImageView.image  = selectedImage
        self.postImageView.isHidden = false
        self.postImageViewButtonHight.constant = 150
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
    
    @IBAction func deleteBackroundImage(sender: UIButton){
        
    }
    
}
