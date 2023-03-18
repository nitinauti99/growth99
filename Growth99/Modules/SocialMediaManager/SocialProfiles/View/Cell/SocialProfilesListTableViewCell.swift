//
//  SocialProfilesTableViewCell.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit

protocol SocialProfilesListTableViewCellDelegate: AnyObject {
    func removeSocialProfile(cell: SocialProfilesListTableViewCell, index: IndexPath)
    func editSocialProfiles(cell: SocialProfilesListTableViewCell, index: IndexPath)
}

class SocialProfilesListTableViewCell: UITableViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var questionnaireSelection: UIButton!
    @IBOutlet weak var subView: UIView!
    
    weak var delegate: SocialProfilesListTableViewCellDelegate?
    var dateFormater : DateFormaterProtocol?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormater = DateFormater()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCellWithSearch(questionarieVM: SocialProfilesListViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.socialProfilesFilterListDataAtIndex(index: index.row)
        self.name.text = questionarieVM?.name
        self.id.text = String(questionarieVM?.id ?? 0)
        indexPath = index
    }
    
    func configureCell(questionarieVM: SocialProfilesListViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.socialProfilesListDataAtIndex(index: index.row)
        self.name.text = questionarieVM?.name
        self.id.text = String(questionarieVM?.id ?? 0)
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeSocialProfile(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editSocialProfiles(cell: self, index: indexPath)
    }
    
}
