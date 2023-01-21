//
//  PateintListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import UIKit

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

    var indexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }

    func configureCell(userVM: PateintListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.userDataAtIndex(index: index.row)
        self.firstName.text = userVM?.firstName
        self.lastName.text = userVM?.lastName
        self.id.text = String(userVM?.id ?? 0)
        self.email.text = userVM?.email
        self.createdDate.text =  dateFormater?.serverToLocal(date: userVM?.createdAt ?? "")
        self.updatedDate.text =  dateFormater?.serverToLocal(date: userVM?.updatedAt ?? "")
        self.createdBy.text = userVM?.createdBy
        self.updatedBy.text = userVM?.updatedBy
        let movement = userVM?.patientStatus
        pateintStatusLbi.text = userVM?.patientStatus
        pateintStatusImage.image = UIImage(named: movement ?? "")
        indexPath = index
    }

}
