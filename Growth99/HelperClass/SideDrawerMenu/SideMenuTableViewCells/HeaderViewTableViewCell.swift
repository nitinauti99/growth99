//
//  HeaderViewTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 05/11/22.
//

import UIKit
import Alamofire

class HeaderViewTableViewCell: UITableViewCell {
    @IBOutlet weak var loogo: UIImageView!
    @IBOutlet weak var bussinessTitle: UILabel!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var role: UILabel!
    let user = UserRepository.shared

    func configure() {
        bussinessTitle.text = user.bussinessName
        role.text = UserRepository.shared.roles
        guard let image = self.profileIcon.image else { return }
        print(image)
        profileIcon.sd_setImage(with: URL(string: user.bussinessLogo ?? ""), placeholderImage: UIImage(named: "Logo.png"))
    }
}
