//
//  leadTimeLineTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import UIKit

protocol leadTimeLineTableViewCellProtocol:AnyObject {
    func viewTemplate(cell: leadTimeLineTableViewCell, index: IndexPath,templateId: Int)
}
class leadTimeLineTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var createdDateTime: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var subView: UIView!
    var templateId = Int()

    weak var delegate: leadTimeLineTableViewCellProtocol?
    var dateFormater : DateFormaterProtocol?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        type.layer.borderWidth = 1
        type.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
        type.layer.cornerRadius = 5
        dateFormater = DateFormater()
    }
    
    func configureCell(timeLineVM: leadTimeLineViewModelProtocol?, index: IndexPath) {
        let timeLineVM = timeLineVM?.leadTimeLineDataAtIndex(index: index.row)
        self.name.text = timeLineVM?.name
        self.email.text = timeLineVM?.email
        self.type.text =  timeLineVM?.type ?? String.blank
        self.createdDateTime.text = dateFormater?.serverToLocalPateintTimeLineDate(date: timeLineVM?.createdDateTime ?? String.blank)
        self.indexPath = index
        self.templateId = timeLineVM?.id ?? 0
    }
    
    
    @IBAction func viewTemplateButtonPressed() {
        self.delegate?.viewTemplate(cell: self, index: indexPath,templateId: self.templateId)
    }
}
