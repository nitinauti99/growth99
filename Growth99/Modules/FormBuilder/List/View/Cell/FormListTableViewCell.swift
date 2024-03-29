//  FormListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 13/02/23.
//

protocol FormListTableViewCellDelegate: AnyObject {
    func removePatieint(cell: FormListTableViewCell, index: IndexPath)
}

class FormListTableViewCell: UITableViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var updatedAt: UILabel!
    @IBOutlet private weak var NumberOfQustion: UILabel!
    @IBOutlet private weak var templateFor: UILabel!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet weak var editButtonAction: UIButton!

    var dateFormater: DateFormaterProtocol?
    weak var delegate: FormListTableViewCellDelegate?

    var indexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }

    func configureCellisSearch(FormList: FormListViewModelProtocol?, index: IndexPath) {
        let FormList = FormList?.formFilterDataAtIndex(index: index.row)
        self.name.text = FormList?.name
        self.id.text = String(FormList?.id ?? 0)
        self.NumberOfQustion.text = String(FormList?.noOfQuestions ?? 0)
        self.createdAt.text = dateFormater?.serverToLocal(date: FormList?.createdAt ?? String.blank)
        self.updatedAt.text =  dateFormater?.serverToLocal(date: FormList?.updatedAt ?? String.blank)
        indexPath = index
    }
    
    func configureCell(FormList: FormListViewModelProtocol?, index: IndexPath) {
        let FormList = FormList?.FormDataAtIndex(index: index.row)
        self.name.text = FormList?.name
        self.id.text = String(FormList?.id ?? 0)
        self.NumberOfQustion.text = String((FormList?.noOfQuestions ?? Int("-")) ?? 0)
        self.createdAt.text = dateFormater?.serverToLocal(date: FormList?.createdAt ?? String.blank)
        self.updatedAt.text =  dateFormater?.serverToLocal(date: FormList?.updatedAt ?? String.blank)
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removePatieint(cell: self, index: indexPath)
    }
    
}
