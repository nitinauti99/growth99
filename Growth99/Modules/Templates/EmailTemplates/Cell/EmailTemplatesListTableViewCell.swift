//
//  EmailTemplatesListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//

import UIKit

class EmailTemplatesListTableViewCell: UITableViewCell {
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

    func configureCell(emailTemplateList: EmailTemplateViewModelProtocol?, index: IndexPath, selectedIndex: Int) {
        let emailTemplateList = emailTemplateList?.emailTemplateDataAtIndex(index: index.row, selectedIndex: selectedIndex)
        self.name.text = emailTemplateList?.name
        self.id.text = String(emailTemplateList?.id ?? 0)
        self.createdBy.text = emailTemplateList?.createdBy
        self.templateFor.text = emailTemplateList?.templateFor
        self.createdAt.text = dateFormater?.serverToLocal(date: emailTemplateList?.createdAt ?? "")
        self.updatedAt.text =  dateFormater?.serverToLocal(date: emailTemplateList?.updatedAt ?? "")
        indexPath = index
    }
}
