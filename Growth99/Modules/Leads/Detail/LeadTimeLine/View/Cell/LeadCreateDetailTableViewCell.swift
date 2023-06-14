//
//  LeadCreateDetailTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 14/06/23.
//

import UIKit

class LeadCreateDetailTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var createdDateTime: UILabel!

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var subView: UIView!
    var dateFormater : DateFormaterProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        type.layer.borderWidth = 1
        type.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
        type.layer.cornerRadius = 5
        dateFormater = DateFormater()
    }
    
    func configureCell(timeLineVM: leadTimeLineViewModelProtocol?, index: Int) {
        let timeLineVM = timeLineVM?.getCreationData
        self.firstName.text = (timeLineVM?.firstName ?? "") + " " + (timeLineVM?.lastName ?? "")
        self.type.text =  "Lead Created"
        self.createdDateTime.text = dateFormater?.serverToLocalPateintTimeLineDate(date: timeLineVM?.createdAt ?? String.blank)
    }
}
