//
//  CreateSMSTemplateViewController+CollectionView.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation
import UIKit

extension CreateSMSTemplateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getSMSVariableListData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateSMSTemplateCollectionViewCell", for: indexPath) as? CreateSMSTemplateCollectionViewCell else { return UICollectionViewCell()}
        
        cell.configureCell(smsTemplateList: viewModel, index: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let smsTemplateList = viewModel?.getCreateSMSTemplateistData(index: indexPath.row)
        let text = smsTemplateList?.label
        let cellWidth = (text?.size(withAttributes:[.font: UIFont.systemFont(ofSize:14)]).width ?? 0)
        return CGSize(width: cellWidth, height: 25.0)
    }
}
