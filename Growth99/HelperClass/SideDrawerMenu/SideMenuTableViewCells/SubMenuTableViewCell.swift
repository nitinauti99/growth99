//
//  SubMenuTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 05/11/22.
//

import UIKit

class SubMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var forwordArrow: UIImageView!
    
    func configure(titleData: menuList, row: Int){
        self.menuTitle.text = titleData.subMenuList?[row].title
        menuIcon.image = UIImage.fontAwesomeIcon(code: titleData.subMenuList?[row].imageName ?? "", style: .solid, textColor: UIColor.black, size: CGSize(width: 25, height: 25))
    }
}
