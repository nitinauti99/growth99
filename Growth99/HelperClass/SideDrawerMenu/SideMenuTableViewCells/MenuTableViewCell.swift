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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -15, right: 0))
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction))
        self.addGestureRecognizer(self.tapGesture!)
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.tappedSection(cell: self, section: section, title: self.title ?? "")
    }
    
    func configure(mainMenuList: menuList, section: Int, delegate: SubMenuTableViewCellDelegate) {
        self.section = section
        self.delegate = delegate
        self.title = mainMenuList.title
        self.menuTitle.text = mainMenuList.title
        menuIcon.image = UIImage.fontAwesomeIcon(code: mainMenuList.imageName ?? "", style: .solid, textColor: UIColor.black, size: CGSize(width: 25, height: 25))
        if mainMenuList.subMenuList?.count == nil {
            self.forwordArrow.isHidden = true
        } else{
            self.forwordArrow.isHidden = false
        }
    }
}
