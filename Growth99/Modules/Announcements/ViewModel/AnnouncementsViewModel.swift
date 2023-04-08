//
//  AnnouncementsViewModel.swift
//  Growth99
//
//  Created by Sravan Goud on 05/03/23.
//

import Foundation

protocol AnnouncementsViewModelProtocol {
    func getAnnouncements()

    func getAnnouncementsFilterData(searchText: String)
    
    func getAnnouncementsDataAtIndex(index: Int)-> AnnouncementsModel?
    func getAnnouncementsFilterDataAtIndex(index: Int)-> AnnouncementsModel?
    
    var  getAnnouncementsData: [AnnouncementsModel] { get }
    var  getAnnouncementsFilterData: [AnnouncementsModel] { get }
    
    func removeSelectedMassEmail(MassEmailId: Int)
}

class AnnouncementsViewModel {
    var delegate: AnnouncementsViewContollerProtocol?
    var announcementsList: [AnnouncementsModel] = []
    var announcementsListFilterData: [AnnouncementsModel] = []
    
    init(delegate: AnnouncementsViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getAnnouncements() {
        self.requestManager.request(forPath: ApiUrl.getAnnouncementsList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[AnnouncementsModel], GrowthNetworkError>) in
            switch result {
            case .success(let announcementsData):
                self.announcementsList = announcementsData
                self.delegate?.announcementsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension AnnouncementsViewModel: AnnouncementsViewModelProtocol {
    func removeSelectedMassEmail(MassEmailId: Int) {
        
    }
    
    func getAnnouncementsFilterData(searchText: String) {
        self.announcementsListFilterData = self.getAnnouncementsData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.description?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let urlMatch = task.url?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || urlMatch || idMatch
        }
    }
    
    func getAnnouncementsDataAtIndex(index: Int)-> AnnouncementsModel? {
        return self.getAnnouncementsData[index]
    }
    
    func getAnnouncementsFilterDataAtIndex(index: Int)-> AnnouncementsModel? {
        return self.announcementsListFilterData[index]
    }
    
    var getAnnouncementsData: [AnnouncementsModel] {
        return self.announcementsList
    }
   
    var getAnnouncementsFilterData: [AnnouncementsModel] {
         return self.announcementsListFilterData
    }
}
