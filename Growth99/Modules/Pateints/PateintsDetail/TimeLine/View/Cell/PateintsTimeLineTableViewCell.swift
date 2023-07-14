//
//  PateintsTimeLineTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import UIKit

protocol PateintsTimeLineTableViewCellProtocol:AnyObject {
    func viewTemplate(cell: PateintsTimeLineTableViewCell, index: IndexPath, templateId: Int)
}

class PateintsTimeLineTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var createdDateTime: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var subView: UIView!
    weak var delegate: PateintsTimeLineTableViewCellProtocol?
    var dateFormater : DateFormaterProtocol?
    var indexPath = IndexPath()
    var templateId = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        type.layer.borderWidth = 1
        type.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
        type.layer.cornerRadius = 5
        dateFormater = DateFormater()
    }
    
    func configureCell(timeLineVM: PateintsTimeLineViewModelProtocol?, index: IndexPath) {
        let timeLineVM = timeLineVM?.pateintsTimeLineDataAtIndex(index: index.row)
        self.name.text = timeLineVM?.name
        if timeLineVM?.type == "SMS" || timeLineVM?.type == "CUSTOM_SMS" || timeLineVM?.type == "MANUAL_SMS" ||  timeLineVM?.type == "MASS_SMS"{
            self.email.text = timeLineVM?.phoneNumber
        }else{
            self.email.text = timeLineVM?.email
        }
        self.type.text =  timeLineVM?.type ?? String.blank
        self.createdDateTime.text = dateFormater?.serverToLocalPateintTimeLineDate(date: timeLineVM?.createdDateTime ?? String.blank)
        self.indexPath = index
        self.templateId = timeLineVM?.id ?? 0
        
    }
    
    @IBAction func viewTemplateButtonPressed() {
        self.delegate?.viewTemplate(cell: self, index: indexPath, templateId: self.templateId)
    }
}
