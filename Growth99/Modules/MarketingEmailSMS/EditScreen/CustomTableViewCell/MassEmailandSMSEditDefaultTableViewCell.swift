//
//  MassEmailandSMSEditDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSEditDefaultCellDelegate: AnyObject {
    func nextButtonDefault(cell: MassEmailandSMSEditDefaultTableViewCell, index: IndexPath)
}

class MassEmailandSMSEditDefaultTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    @IBOutlet weak var massEmailSMSTextField: CustomTextField!
    @IBOutlet weak var defaultNextButton: UIButton!
    
    weak var delegate: MassEmailandSMSEditDefaultCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sFender: UIButton) {
        self.delegate?.nextButtonDefault(cell: self, index: indexPath)
    }
}
