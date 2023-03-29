//
//  PostImageListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 25/03/23.
//

import Foundation
import UIKit

extension PostImageListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getSocialPostImageList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostImageListTableViewCell", for: indexPath) as? PostImageListTableViewCell else { return UITableViewCell() }

        cell.configureCell(mediaLibraryListVM: viewModel, index: indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = viewModel?.getSocialPostImageListDataAtIndex(index: indexPath.row)
        self.delegate?.getSocialPostImageListDataAtIndex(content: content!)
        self.dismiss(animated: true)
      
    }
}
