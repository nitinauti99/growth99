//
//  SpinnerView.swift
//  Growth99
//
//  Created by nitin auti on 02/11/22.
//

import Foundation
import UIKit

extension UIView {
    public func ShowSpinner() {
        let spinnerActivity = MBProgressHUD.showAdded(to: self, animated: true)
        spinnerActivity.mode = MBProgressHUDMode.indeterminate
       // spinnerActivity.bezelView.color = UIColor.init(hexString: "#009EDE")
     //   spinnerActivity.bezelView.style = .solidColor
        spinnerActivity.label.text = "Loading"
        //spinnerActivity.label.textColor = .white
//        spinnerActivity.detailsLabel.text = "Please Wait!!"
        spinnerActivity.isUserInteractionEnabled = false
    }

    public func HideSpinner(){
        MBProgressHUD.hide(for: self, animated: true)
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: 50, y: self.frame.size.height-100, width: self.frame.size.width - 100, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Avenir Next Medium", size: 15)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
      }
}
