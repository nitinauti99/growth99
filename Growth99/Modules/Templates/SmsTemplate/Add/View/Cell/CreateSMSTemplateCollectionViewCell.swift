//
//  CreateSMSTemplateCollectionViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import UIKit

class CreateSMSTemplateCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var labelButton: UIButton!

    var indexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(smsTemplateList: CreateSMSTemplateViewModelProtocol?, index: IndexPath) {
        let smsTemplateList = smsTemplateList?.getCreateSMSTemplateistData(index: index.row)
        let str : String = "   + \(smsTemplateList?.label ?? "")   "
        self.labelButton.setTitle(str, for: .normal)
        indexPath = index
    }
}
