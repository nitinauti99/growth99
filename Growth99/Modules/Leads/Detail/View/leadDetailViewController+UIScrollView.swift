//
//  leadDetailViewController+UIScrollView.swift
//  Growth99
//
//  Created by Nitin Auti on 15/03/23.
//

import Foundation
import UIKit

extension leadDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewHight.constant = tableViewHeight + 500
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHight.constant = tableViewHeight + 500
    }
}
