//
//  CategoriesListTableViewCell.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

class CategoriesListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedDate: UILabel!
    @IBOutlet private weak var updatedBy: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    var indexPath = IndexPath()
    var dateFormater: DateFormaterProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }

    func configureCell(categoriesFilterList: CategoriesListViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let categoriesList = categoriesFilterList?.getCategoriesFilterDataAtIndex(index: index.row)
        self.nameLabel.text = categoriesList?.name
        self.id.text = String(categoriesList?.id ?? 0)
        self.createdDate.text = dateFormater?.serverToLocal(date: categoriesList?.createdAt ?? String.blank)
        self.updatedDate.text = dateFormater?.serverToLocal(date: categoriesList?.updatedAt ?? String.blank)
        self.createdBy.text = categoriesList?.createdBy
        self.updatedBy.text = categoriesList?.updatedBy
        indexPath = index
    }
    
    func configureCell(categoriesListData: CategoriesListViewModelProtocol?, index: IndexPath) {
        let categoriesList = categoriesListData?.getCategoriesDataAtIndex(index: index.row)
        self.nameLabel.text = categoriesList?.name
        self.id.text = String(categoriesList?.id ?? 0)
        self.createdDate.text = dateFormater?.serverToLocal(date: categoriesList?.createdAt ?? String.blank)
        self.updatedDate.text = dateFormater?.serverToLocal(date: categoriesList?.updatedAt ?? String.blank)
        self.createdBy.text = categoriesList?.createdBy
        self.updatedBy.text = categoriesList?.updatedBy
        indexPath = index
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date! as Date)
    }
    
}
