//
//  UITableView+Extension.swift
//  Growth99
//
//  Created by Sravan Goud on 12/02/23.
//

import Foundation
import UIKit

extension UITableView {
    
    func setEmptyMessage(arrayCount: Int) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        if arrayCount == 0 {
            messageLabel.text = Constant.Profile.tableViewEmptyText
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
            messageLabel.sizeToFit()
            self.backgroundView = messageLabel
        }else{
            self.backgroundView = nil
        }
        self.separatorStyle = .none
    }
    
    
    func setEmptyMessage() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = Constant.Profile.tableViewEmptyText
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    func register<T: UITableViewCell>(cellType: T.Type) where T: ClassIdentifiable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseId)
    }

    func register<T: UITableViewCell>(cellType: T.Type) where T: NibIdentifiable & ClassIdentifiable {
        register(cellType.nib, forCellReuseIdentifier: cellType.reuseId)
    }

    func dequeueReusableCell<T: UITableViewCell>(withCellType type: T.Type = T.self) -> T where T: ClassIdentifiable {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseId) as? T else { fatalError(dequeueError(withIdentifier: type.reuseId, type: self)) }

        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(withCellType type: T.Type = T.self, forIndexPath indexPath: IndexPath) -> T where T: ClassIdentifiable {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseId, for: indexPath) as? T else { fatalError(dequeueError(withIdentifier: type.reuseId, type: self)) }
        return cell
    }
}
