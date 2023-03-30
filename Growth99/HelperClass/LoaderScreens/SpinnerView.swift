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
        self.LoaderConfiguration()
        SwiftLoader.show(title: "Loading...", animated: true)
    }
    
    func LoaderConfiguration(){
         var config : SwiftLoader.Config = SwiftLoader.Config()
         config.size = 150
         config.spinnerColor = .red
         config.titleTextColor = UIColor.init(hexString: "#009EDE")
         config.foregroundColor = UIColor.init(hexString: "#009EDE")
         config.foregroundAlpha = 0.5
    }

    public func HideSpinner(){
        SwiftLoader.hide()
    }
    
    func showToast(message : String , color: UIColor?) {
        let toastLabel = UILabel(frame: CGRect(x: 30, y: self.frame.size.height-150, width: self.frame.size.width - 60, height: 60))
        toastLabel.backgroundColor = color ?? UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Avenir Next Medium", size: 15)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.numberOfLines = 0
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
