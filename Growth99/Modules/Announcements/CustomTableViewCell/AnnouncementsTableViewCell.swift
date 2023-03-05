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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCell(announcementsFilterList: AnnouncementsModel?, index: IndexPath, isSearch: Bool) {
        self.id.text = String(announcementsFilterList?.id ?? 0)
        self.urlTextView.text = announcementsFilterList?.url
        self.releaseDateLabel.text =  self.serverToLocal(date: announcementsFilterList?.releaseDate ?? String.blank)
        self.descriptionLabel.text = announcementsFilterList?.description
        indexPath = index
    }
    
    func configureCell(announcementsList: AnnouncementsModel?, index: IndexPath, isSearch: Bool) {
        self.id.text = String(announcementsList?.id ?? 0)
        self.urlTextView.text = announcementsList?.url
        self.releaseDateLabel.text =  self.serverToLocal(date: announcementsList?.releaseDate ?? String.blank)
        self.descriptionLabel.text = announcementsList?.description
        indexPath = index
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM d yyyy"
        return dateFormatter.string(from: date)
    }

    func serverToLocalCreatedDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM d yyyy"
        return dateFormatter.string(from: date)
    }
    
    func utcToLocal(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
