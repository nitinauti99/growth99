//
//  AnnouncementsTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 05/03/23.
//

import UIKit

class AnnouncementsTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var urlTextView: UITextView!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var subView: UIView!

    var indexPath = IndexPath()
    var dateFormater : DateFormaterProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()

    }
    
    func configureCell(announcementsFilterList: AnnouncementsModel?, index: IndexPath, isSearch: Bool) {
        self.id.text = String(announcementsFilterList?.id ?? 0)
        self.urlTextView.text = announcementsFilterList?.url
        self.releaseDateLabel.text =  dateFormater?.serverToLocalDateConverter(date: announcementsFilterList?.releaseDate ?? String.blank)
        self.descriptionLabel.text = announcementsFilterList?.description
        indexPath = index
    }
    
    func configureCell(announcementsList: AnnouncementsModel?, index: IndexPath, isSearch: Bool) {
        self.id.text = String(announcementsList?.id ?? 0)
        self.urlTextView.text = announcementsList?.url
        self.releaseDateLabel.text = dateFormater?.serverToLocalDateConverter(date: announcementsList?.releaseDate ?? String.blank)
        self.descriptionLabel.text = announcementsList?.description
        indexPath = index
    }

}
