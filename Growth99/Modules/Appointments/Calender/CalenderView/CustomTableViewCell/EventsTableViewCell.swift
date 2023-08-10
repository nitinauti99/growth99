//
//  EventsTableViewCell.swift
//  Growth99
//
//  Created by admin on 25/12/22.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventsLineView: UIView!
    @IBOutlet weak var eventsTitle: UILabel!
    @IBOutlet weak var eventsDuration: UILabel!
    @IBOutlet weak var eventsDate: UIButton!
    @IBOutlet private weak var unReadImage: UIImageView!

    var dateFormater : DateFormaterProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eventsLineView.roundCornersView(corners: [.topLeft, .bottomLeft], radius: 10)
        dateFormater = DateFormater()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(headline: AppointmentDTOList, index: IndexPath) {
        self.eventsTitle.text = "\(headline.patientFirstName ?? String.blank) \(headline.patientLastName ?? String.blank)"
        let startTime = convertToUTCString(from: headline.appointmentStartDate ?? "")
        let endTime = convertToUTCString(from: headline.appointmentEndDate ?? "")
        self.eventsDuration.text = "\(startTime) - \(endTime)"
        self.eventsDate.setTitle(headline.appointmentStartDate?.toDate()?.toString(), for: .normal)
        self.selectionStyle = .none
        if headline.appointmentRead == true {
            self.unReadImage.isHidden = true
        }else{
            self.unReadImage.isHidden = false
        }
    }
    
    func convertToUTCString(from timestampString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        guard let date = dateFormatter.date(from: timestampString) else {
            print("Error: Invalid timestamp format")
            return ""
        }

        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
}
