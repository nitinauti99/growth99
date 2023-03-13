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
        if selectedIndex == 0 {
            return viewModel?.getLeadVariableListData.count ?? 0
        }else if (selectedIndex == 1){
            return viewModel?.getAppointMentVariableListData.count ?? 0
        }else {
            return viewModel?.getSMSVariableListData.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateSMSTemplateCollectionViewCell", for: indexPath) as? CreateSMSTemplateCollectionViewCell else { return UICollectionViewCell()}
        cell.delegate = self
        cell.configureCell(smsTemplateList: viewModel, index: indexPath, selectedIndex: self.selectedIndex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var smsTemplateList: CreateSMSTemplateModel?

        if selectedIndex == 0 {
            smsTemplateList =  viewModel?.getLeadTemplateListData(index: indexPath.row)
        }else if (selectedIndex == 1){
            smsTemplateList =  viewModel?.getAppointmentTemplateListData(index: indexPath.row)
        }else {
            smsTemplateList =  viewModel?.getMassSMSTemplateListData(index: indexPath.row)
        }
        let text = smsTemplateList?.label
        let cellWidth = (text?.size(withAttributes:[.font: UIFont.systemFont(ofSize:14)]).width ?? 0)
        return CGSize(width: cellWidth, height: 22.0)
    }

}
