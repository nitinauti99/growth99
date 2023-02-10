//
//  QuestionnaireTemplateListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 10/02/23.
//

import UIKit

class QuestionnaireTemplateListTableViewCell: UITableViewCell {

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

    func configureCell(questionnaireTemplateList: QuestionnaireTemplateListViewModelProtocol?, index: IndexPath) {
        let questionnaireTemplateList = questionnaireTemplateList?.questionnaireTemplateDataAtIndex(index: index.row)
        self.name.text = questionnaireTemplateList?.name
        self.id.text = String(questionnaireTemplateList?.id ?? 0)
        self.createdBy.text = questionnaireTemplateList?.createdBy
        self.templateFor.text = questionnaireTemplateList?.templateFor
        self.createdAt.text = dateFormater?.serverToLocal(date: questionnaireTemplateList?.createdAt ?? "")
        self.updatedAt.text =  dateFormater?.serverToLocal(date: questionnaireTemplateList?.updatedAt ?? "")
        indexPath = index
    }
}
