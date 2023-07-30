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
        let startTime = dateFormater?.serverToLocalforCalender(date: headline.appointmentStartDate ?? String.blank)
        let endTime = dateFormater?.serverToLocalforCalender(date: headline.appointmentEndDate ?? String.blank)
        self.eventsDuration.text = "\(startTime ?? "") - \(endTime ?? "")"
        self.eventsDate.setTitle(headline.appointmentStartDate?.toDate()?.toString(), for: .normal)
        self.selectionStyle = .none
    }
}
