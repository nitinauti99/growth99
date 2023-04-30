//
//  MediaLibraryAddViewController+UIImagePickerController.swift
//  Growth99
//
//  Created by Nitin Auti on 21/03/23.
//

import Foundation
import Photos

extension MediaLibraryAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    @IBAction func browseImagAction(sender: UIButton){
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.mediaImage.image  = selectedImage
        self.mediaImage.isHidden = false
        self.deleteBackroundImageButton.isHidden = false
        self.browseImageButton.isHidden = true
        self.browseImagButtonHight.constant = 210
        if let asset = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.phAsset.rawValue)] as? PHAsset {
            let assetResources = PHAssetResource.assetResources(for: asset)
            print(assetResources.first!.originalFilename)
            self.imageName = assetResources.first!.originalFilename
          }
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
