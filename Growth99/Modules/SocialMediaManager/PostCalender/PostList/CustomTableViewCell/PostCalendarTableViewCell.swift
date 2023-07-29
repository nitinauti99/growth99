//
//  PostCalendarTableViewCell.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit

class PostCalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shortDateBtn: UIButton!
    @IBOutlet weak var editButton: UIImageView!
    @IBOutlet weak var postLineView: UIView!
    var postCalendarViewModel: PostCalendarViewModelProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postLineView.roundCornersView(corners: [.topLeft, .bottomLeft], radius: 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(headline: PostCalendarListModel, index: IndexPath) {
        self.postLabel.text = "\(headline.post ?? String.blank)"
        self.statusButton.setTitle(headline.approved ?? false ? "Approved" : "Pending", for: .normal)
        self.statusButton.titleLabel?.textColor = headline.approved ?? false ? UIColor(hexString: "52afff") : UIColor.red
        self.statusButton.layer.borderColor = headline.approved ?? false ? UIColor(hexString: "52afff").cgColor : UIColor.red.cgColor
        self.timeLabel.text = convertTo12HourFormat(headline.scheduledDate ?? "")
        self.shortDateBtn.setTitle(headline.scheduledDate?.toDate()?.toString(), for: .normal)
        self.selectionStyle = .none
    }
    
    func convertTo12HourFormat(_ dateString: String) -> String {
        let timeZone =  UserRepository.shared.timeZone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "hh:mm a"
            outputFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
            return outputFormatter.string(from: date)
        } else {
            return "Invalid date format."
        }
    }
}
