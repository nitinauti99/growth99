//
//  FileTypeTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 13/06/23.
//

import UIKit

protocol FileTypeTableViewCellProtocol: AnyObject {
    func presentImagePickerController(pickerController: UIImagePickerController)
    func dissmissImagePickerController()
}

class FileTypeTableViewCell: UITableViewCell, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var selectFile: UIButton!
    @IBOutlet weak var selectedLbi: UILabel!
    @IBOutlet weak var asteriskSign: UILabel!

    var delegate: FileTypeTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectFile.layer.borderColor = UIColor.gray.cgColor;
        selectFile.layer.borderWidth = 1.0;
    }

    func configureCell(questionarieVM: CreateLeadViewModelProtocol?, index: IndexPath) {
        
    }
    
    @IBAction func selectButtonPressed(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        delegate?.presentImagePickerController(pickerController: imagePickerController)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let data = image.pngData() {
                let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
                print("image url", filename)
                try? data.write(to: filename)
            }
        }
//        self.selectedLbi.text  = selectedImage
        delegate?.dissmissImagePickerController()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
