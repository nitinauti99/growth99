//
//  PateintListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import UIKit

protocol PateintListTableViewCellDelegate: AnyObject {
    func removePatieint(cell: PateintListTableViewCell, index: IndexPath)
    func editPatieint(cell: PateintListTableViewCell, index: IndexPath)
    func detailPatieint(cell: PateintListTableViewCell, index: IndexPath)
}

class PateintListTableViewCell: UITableViewCell {

    @IBOutlet private weak var firstName: UILabel!
    @IBOutlet private weak var lastName: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedDate: UILabel!
    @IBOutlet private weak var updatedBy: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var pateintStatusImage: UIImageView!
    @IBOutlet private weak var pateintStatusLbi: UILabel!
    @IBOutlet weak var editButtonAction: UIButton!

    var dateFormater : DateFormaterProtocol?
    var buttonAddTimeTapCallback: () -> ()  = { }
    weak var delegate: PateintListTableViewCellDelegate?

    var indexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }

    func configureCell(userVM: PateintListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.pateintDataAtIndex(index: index.row)
        self.firstName.text = userVM?.firstName
        self.lastName.text = userVM?.lastName
        self.id.text = String(userVM?.id ?? 0)
        self.email.text = userVM?.email
        self.createdDate.text =  dateFormater?.serverToLocalforPateints(date: userVM?.createdAt ?? String.blank)
        self.updatedDate.text =  dateFormater?.serverToLocalforPateints(date: userVM?.updatedAt ?? String.blank)
        self.createdBy.text = userVM?.createdBy
        self.updatedBy.text = userVM?.updatedBy
        let movement = userVM?.patientStatus
        pateintStatusLbi.text = userVM?.patientStatus
        pateintStatusImage.image = UIImage(named: movement?.uppercased() ?? String.blank)
        indexPath = index
    }

    func configureCellWithSearch(userVM: PateintListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.pateintFilterDataAtIndex(index: index.row)
        self.firstName.text = userVM?.firstName
        self.lastName.text = userVM?.lastName
        self.id.text = String(userVM?.id ?? 0)
        self.email.text = userVM?.email
        self.createdDate.text =  dateFormater?.serverToLocalforPateints(date: userVM?.createdAt ?? String.blank)
        self.updatedDate.text =  dateFormater?.serverToLocalforPateints(date: userVM?.updatedAt ?? String.blank)
        self.createdBy.text = userVM?.createdBy
        self.updatedBy.text = userVM?.updatedBy
        let movement = userVM?.patientStatus
        pateintStatusLbi.text = userVM?.patientStatus
        pateintStatusImage.image = UIImage(named: movement?.uppercased() ?? String.blank)
        indexPath = index
    }
    @IBAction func deleteButtonPressed() {
        self.delegate?.removePatieint(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editPatieint(cell: self, index: indexPath)
    }
    
    @IBAction func detailButtonPressed() {
        self.delegate?.detailPatieint(cell: self, index: indexPath)
    }
}
