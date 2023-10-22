//
//  FileTypeTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 13/06/23.
//

import UIKit
import Photos

protocol FileTypeTableViewCellProtocol: AnyObject {
    func presentImagePickerController(pickerController: UIImagePickerController)
    func dissmissImagePickerController(id: Int, questionId: Int, image: UIImage)
    
}

class FileTypeTableViewCell: UITableViewCell, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var selectFile: UIButton!
    @IBOutlet weak var selectedLbi: UILabel!
    @IBOutlet weak var asteriskSign: UILabel!

    
    var delegate: FileTypeTableViewCellProtocol?
    var imageName = String()
    var imageUrl = String()
    var id = Int()
    var questionId = Int()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectFile.layer.borderColor = UIColor.gray.cgColor;
        selectFile.layer.borderWidth = 1.0;
    }

    func configureCell(questionarieVM: CreateLeadViewModelProtocol?, index: IndexPath, id: Int) {
        let questionarie = questionarieVM?.getLeadQuestionnaireListAtIndex(index: index.row)
        self.questionId = questionarie?.questionId ?? 0
        self.id = id
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
        
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            let imageName = imageURL.lastPathComponent
            self.imageName = imageName
            self.selectedLbi.text = imageName
        } else {
            print("Image URL not available.")
        }
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.delegate?.dissmissImagePickerController(id: id, questionId: self.questionId, image: image)

        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
