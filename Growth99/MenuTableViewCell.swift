//
//  SubMenuTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 06/11/22.
//

import UIKit

protocol SubMenuTableViewCellDelegate {
    func tappedSection(cell: MenuTableViewCell, section: Int, title: String)
}

class MenuTableViewCell: UITableViewHeaderFooterView {
     @IBOutlet weak var menuIcon: UIImageView!
     @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var forwordArrow: UIImageView!
     private var tapGesture : UITapGestureRecognizer?
     var delegate: SubMenuTableViewCellDelegate?
     var section: Int!
     var title: String?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction))
        self.addGestureRecognizer(self.tapGesture!)
    }

    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.tappedSection(cell: self, section: section, title: self.title ?? "")
    }
    
    func configure(mainMenuList: menuList, section: Int, delegate: SubMenuTableViewCellDelegate){
        self.section = section
        self.delegate = delegate
        self.title = mainMenuList.title
        self.menuTitle.text = mainMenuList.title
        let image: UIImage = UIImage(named: mainMenuList.imageName ?? "") ?? UIImage(named: "Logo")!
        self.menuIcon.image = image
        if mainMenuList.subMenuList?.count == nil {
            self.forwordArrow.isHidden = true
        } else{
            self.forwordArrow.isHidden = false
        }
    }
    
}
