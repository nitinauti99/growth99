//
//  SMSTemplatesListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//

import UIKit

class SMSTemplatesListTableViewCell: UITableViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedAt: UILabel!
    @IBOutlet private weak var templateFor: UILabel!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet weak var editButtonAction: UIButton!

    var dateFormater : DateFormaterProtocol?
    var buttonAddTimeTapCallback: () -> ()  = { }
    weak var delegate: PateintListTableViewCellDelegate?

    var indexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }

    func configureCell(smsTemplateList: SMSTemplateViewModelProtocol?, index: IndexPath, selectedIndex: Int) {
        let smsTemplateList = smsTemplateList?.getTemplateDataAtIndexPath(index: index.row, selectedIndex: selectedIndex)
        self.name.text = smsTemplateList?.name
        self.id.text = String(smsTemplateList?.id ?? 0)
        self.createdBy.text = smsTemplateList?.createdBy
        self.templateFor.text = smsTemplateList?.templateFor
        self.createdAt.text = dateFormater?.serverToLocal(date: smsTemplateList?.createdAt ?? String.blank)
        self.updatedAt.text =  dateFormater?.serverToLocal(date: smsTemplateList?.updatedAt ?? String.blank)
        indexPath = index
    }
    
    func configureCellisSearch(smsTemplateList: SMSTemplateViewModelProtocol?, index: IndexPath, selectedIndex: Int) {
        let smsTemplateList = smsTemplateList?.getTemplateFilterDataAtIndexPath(index: index.row, selectedIndex: selectedIndex)
        self.name.text = smsTemplateList?.name
        self.id.text = String(smsTemplateList?.id ?? 0)
        self.createdBy.text = smsTemplateList?.createdBy
        self.templateFor.text = smsTemplateList?.templateFor
        self.createdAt.text = dateFormater?.serverToLocal(date: smsTemplateList?.createdAt ?? String.blank)
        self.updatedAt.text =  dateFormater?.serverToLocal(date: smsTemplateList?.updatedAt ?? String.blank)
        indexPath = index
    }
}

