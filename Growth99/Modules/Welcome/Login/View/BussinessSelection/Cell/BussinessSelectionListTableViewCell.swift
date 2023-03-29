//
//  BussinessSelectionListTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 03/03/23.
//

import UIKit

class BussinessSelectionListTableViewCell: UITableViewCell {
    @IBOutlet weak var bussinessImage: UIImageView!
    @IBOutlet weak var bussinessName: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var subView: UIView!
    var buttoneTapCallback: () -> ()  = { }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        self.loginButton.layer.cornerRadius = 12
        self.loginButton.clipsToBounds = true
        self.bussinessImage.layer.cornerRadius = 40
        self.bussinessImage.clipsToBounds = true
        self.bussinessImage.createBorderForView(redius: 40, width: 1)
    }

    @IBAction func loginButtonAction(sender: UIButton) {
        buttoneTapCallback()
    }
}
