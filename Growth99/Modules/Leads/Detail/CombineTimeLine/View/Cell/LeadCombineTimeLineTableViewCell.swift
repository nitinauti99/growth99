//
//  LeadCombineTimeLineTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import UIKit

protocol LeadCombineTimeLineTableViewCellProtocol:AnyObject {
    func viewTemplate(cell: LeadCombineTimeLineTableViewCell, index: IndexPath,templateId: Int)
}

class LeadCombineTimeLineTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var createdDateTime: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var subView: UIView!
    
    var dateFormater : DateFormaterProtocol?
    var templateId = Int()
    var indexPath = IndexPath()
    weak var delegate: LeadCombineTimeLineTableViewCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        type.layer.borderWidth = 1
        type.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
        type.layer.cornerRadius = 5
        dateFormater = DateFormater()
    }
    
    func configureCell(timeLineVM: CombineTimeLineViewModelProtocol?, index: IndexPath) {
        let timeLineVM = timeLineVM?.leadTimeLineDataAtIndex(index: index.row)
        self.name.text = timeLineVM?.name
        if timeLineVM?.type == "SMS" || timeLineVM?.type == "CUSTOM_SMS" || timeLineVM?.type == "MANUAL_SMS" ||  timeLineVM?.type == "MASS_SMS"{
            self.email.text = timeLineVM?.phoneNumber
        }else{
            self.email.text = timeLineVM?.email
        }
        self.type.text =  timeLineVM?.type ?? String.blank
        self.createdDateTime.text = dateFormater?.serverToLocalPateintTimeLineDate(date: timeLineVM?.createdDateTime ?? String.blank)
        self.templateId = timeLineVM?.id ?? 0
        self.indexPath = index
    }
    
    @IBAction func viewTemplateButtonPressed() {
        self.delegate?.viewTemplate(cell: self, index: indexPath,templateId: self.templateId)
    }
}
