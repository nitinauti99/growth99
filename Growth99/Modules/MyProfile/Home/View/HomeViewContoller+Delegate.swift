//
//  HomeViewContoller+Delegate.swift
//  Growth99
//
//  Created by Nitin Auti on 17/07/23.
//

import Foundation

extension HomeViewContoller: HomeViewContollerProtocol{
    
    func userDataRecived() {
        self.viewModel?.getallClinics()
        userProvider.setOn(false, animated: false)
        if viewModel?.getUserProfileData.isProvider ?? false {
            userProvider.setOn(true, animated: false)
            self.userProviderViewHight.constant = 300
            self.userProviderView.isHidden = false
        }
        self.rolesTextField.text = "Admin"
        self.setUpUI()
    }
    
    func clinicsRecived() {
        self.view.HideSpinner()
        // get from user api
        selectedClincs = viewModel?.getUserProfileData.clinics ?? []
        
        /// get From allclinincsapi
        self.allClinics = viewModel?.getAllClinicsData ?? []
        
//        let userTimeZones = self.allClinics.filter({$0.isDefault == true})
//        if let firstTimeZone = userTimeZones.first?.timeZone {
//            UserRepository.shared.timeZone = firstTimeZone
//        }
        
        self.clincsTextField.text = selectedClincs.map({$0.name ?? String.blank}).joined(separator: ", ")
        let selectedClincId = selectedClincs.map({$0.id ?? 0})
        self.selectedClincIds = selectedClincId
        if self.selectedClincIds.count > 0 {
            self.view.ShowSpinner()
            self.viewModel?.getallServiceCategories(SelectedClinics: selectedClincId)
        }
    }
    
    func serviceCategoriesRecived() {
        // get from user api
        self.serviceCategoriesTextField.text = ""
        self.servicesTextField.text = ""
        selectedServiceCategories = viewModel?.getUserProfileData.userServiceCategories ?? []
        allServiceCategories = viewModel?.getAllServiceCategories ?? []
        
        var itemNotPresent:Bool = false
        for item in selectedServiceCategories {
            if allServiceCategories.contains(item) {
                itemNotPresent =  true
            }
        }
        self.serviceCategoriesTextField.text = selectedServiceCategories.map({$0.name ?? String.blank}).joined(separator: ", ")
        let selectedList = selectedServiceCategories.map({$0.id ?? 0})
        self.selectedServiceCategoriesIds = selectedList
        
        if selectedServiceCategories.count == 0 || itemNotPresent == false {
            self.serviceCategoriesTextField.text = ""
        }
        self.view.HideSpinner()
        
        if self.selectedServiceCategories.count > 0 {
            self.view.ShowSpinner()
            self.viewModel?.getallService(SelectedCategories: selectedList)
        }
    }
    
    func serviceRecived() {
        self.view.HideSpinner()
        // get from user api
        self.servicesTextField.text = ""
        selectedService =  viewModel?.getUserProfileData.services ?? []
        allService = viewModel?.getAllService ?? []
        let selectedList = selectedService.map({$0.id ?? 0})
        self.selectedServiceIds = selectedList
        self.servicesTextField.text = selectedService.map({$0.name ?? String.blank}).joined(separator: ", ")
    }
    
    func profileDataUpdated(){
        self.view.HideSpinner()
        self.view.showToast(message: "User updated successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.openUserListView()
        })
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
}

