//
//  ConsentsTemplateListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//

import UIKit

class ConsentsTemplateListTableViewCell: UITableViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedAt: UILabel!
    @IBOutlet private weak var templateFor: UILabel!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet weak var editButtonAction: UIButton!

    var dateFormater: DateFormaterProtocol?
    var buttonAddTimeTapCallback: () -> ()  = { }
    weak var delegate: PateintListTableViewCellDelegate?

    var indexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }

    func configureCell(consentsTemplateList: ConsentsTemplateListViewModelProtocol?, index: IndexPath) {
        let consentsTemplateList = consentsTemplateList?.consentsTemplateDataAtIndex(index: index.row)
        self.name.text = consentsTemplateList?.name
        self.id.text = String(consentsTemplateList?.id ?? 0)
        self.createdBy.text = consentsTemplateList?.createdBy
        self.templateFor.text = consentsTemplateList?.templateFor
        self.createdAt.text = dateFormater?.serverToLocal(date: consentsTemplateList?.createdAt ?? "")
        self.updatedAt.text =  dateFormater?.serverToLocal(date: consentsTemplateList?.updatedAt ?? "")
        indexPath = index
    }
}
