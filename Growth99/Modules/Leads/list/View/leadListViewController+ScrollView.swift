//
//  leadListViewController+ScrollView.swift
//  Growth99
//
//  Created by Nitin Auti on 04/03/23.
//

import Foundation
import UIKit

extension leadListViewController:  UIScrollViewDelegate {
     
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isLoadingList = false
    }
        
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            self.loadMoreItemsForList()
            self.isLoadingList = true
        }
    }
}

