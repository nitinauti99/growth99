//
//  BussinessSelectionViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 03/03/23.
//

import Foundation
import UIKit

extension BussinessSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bussinessSelectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = BussinessSelectionListTableViewCell()
        cell = BussinessSelectionTableView.dequeueReusableCell(withIdentifier: "BussinessSelectionListTableViewCell") as! BussinessSelectionListTableViewCell
        let item = bussinessSelectionData[indexPath.row]
        cell.bussinessName.text = item.name
        cell.bussinessImage.image = UIImage(named: "growthCircleIcon")
        if let url = URL(string: item.logoUrl?.replacingOccurrences(of: "\"", with: "") ?? "") {
           UIImage.loadFrom(url: url) { image in
               if image != nil {
                   cell.bussinessImage.image = self.resizeImage(image: image ?? UIImage(), targetSize: CGSize(width: 60, height: 60))
               }
            }
        }
        cell.buttoneTapCallback = {
            self.loginbuttonPressed(selectedIndex: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
