//
//  MediaTagsListTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 21/03/23.
//

import UIKit

import UIKit

protocol MediaTagsListTableViewCellDelegate: AnyObject {
    func removeMediaTag(cell: MediaTagsListTableViewCell, index: IndexPath)
    func editMediaTag(cell: MediaTagsListTableViewCell, index: IndexPath)
}

class MediaTagsListTableViewCell: UITableViewCell {
   
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var questionnaireSelection: UIButton!
    @IBOutlet weak var subView: UIView!
    
    weak var delegate: MediaTagsListTableViewCellDelegate?
    var dateFormater : DateFormaterProtocol?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormater = DateFormater()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCellWithSearch(questionarieVM: MediaTagsListViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.mediaTagsFilterListDataAtIndex(index: index.row)
        self.name.text = questionarieVM?.name
        self.id.text = String(questionarieVM?.id ?? 0)
        indexPath = index
    }
    
    func configureCell(questionarieVM: MediaTagsListViewModelProtocol?, index: IndexPath) {
        let questionarieVM = questionarieVM?.mediaTagsListDataAtIndex(index: index.row)
        self.name.text = questionarieVM?.name
        self.id.text = String(questionarieVM?.id ?? 0)
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeMediaTag(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editMediaTag(cell: self, index: indexPath)
    }
    
}
