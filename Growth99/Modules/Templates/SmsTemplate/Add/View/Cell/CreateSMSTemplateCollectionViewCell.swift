//
//  CreateSMSTemplateCollectionViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import UIKit

protocol CreateSMSTemplateCollectionViewCellDelegate: AnyObject {
    func selectVariable(cell: CreateSMSTemplateCollectionViewCell, index: IndexPath)
}
class CreateSMSTemplateCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var labelButton: UIButton!
    weak var delegate: CreateSMSTemplateCollectionViewCellDelegate?
    var indexPath = IndexPath()
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(smsTemplateList: CreateSMSTemplateViewModelProtocol?, index: IndexPath, selectedIndex: Int) {
        let str : String?
        
        if selectedIndex == 0 {
           let smsTemplateList =  smsTemplateList?.getLeadTemplateListData(index: index.row)
           str = "   + \(smsTemplateList?.label ?? "")   "
        }else if (selectedIndex == 1){
           let smsTemplateList =  smsTemplateList?.getAppointmentTemplateListData(index: index.row)
            str = "   + \(smsTemplateList?.label ?? "")   "
        }else {
           let smsTemplateList =  smsTemplateList?.getMassSMSTemplateListData(index: index.row)
            str = "   + \(smsTemplateList?.label ?? "")   "
        }
        self.labelButton.setTitle(str, for: .normal)
        indexPath = index
    }
    
    @IBAction func selectedVariableName(sender: UIButton){
        delegate?.selectVariable(cell: self, index: indexPath)
    }
}
