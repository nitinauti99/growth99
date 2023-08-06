//
//  AppointmentListDetailViewController+extension.swift
//  Growth99
//
//  Created by Sravan Goud on 30/07/23.
//

import Foundation

extension AppointmentListDetailViewController {
    
    @IBAction func selectClinicButtonAction(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.clincsTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.clincsTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedClincs  = selectedList
            self?.selectedClincIds = selectedId.first ?? 0
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allClinics.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectServicesButtonAction(sender: UIButton) {
        createSelectedServicesarray.removeAll()
        if selectedServices.count == 0 {
            self.servicesTextField.text = String.blank
        }
        
        for item in allServices {
            for selctedItem in selectedServices {
                if selctedItem.serviceId == item.serviceId {
                    createSelectedServicesarray.append(item)
                }
            }
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allServices, cellType: .subTitle) { (cell, allServices, indexPath) in
            cell.textLabel?.text = allServices.serviceName
        }
        selectionMenu.setSelectedItems(items: createSelectedServicesarray) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.servicesTextField.text = selectedList.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedServices  = selectedList
            self?.selectedServicesIds = selectedId
            self?.view.ShowSpinner()
            self?.eventViewModel?.sendProviderListEditEvent(providerParams: self?.selectedServicesIds.first ?? 0)
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allServices.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectProvidersButtonAction(sender: UIButton) {
        if selectedProviders.count == 0 {
            self.providersTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allProviders, cellType: .subTitle) { (cell, allProviders, indexPath) in
            cell.textLabel?.text = "\(allProviders.firstName ?? String.blank) \(allProviders.lastName ?? String.blank)"
        }
        
        selectionMenu.setSelectedItems(items: selectedProviders) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.providersTextField.text = "\(selectedItem?.firstName ?? String.blank) \(selectedItem?.lastName ?? String.blank)"
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedProviders  = selectedList
            self?.selectedProvidersIds = selectedId.first ?? 0
            self?.view.ShowSpinner()
            self?.eventViewModel?.getDatesList(clinicIds: self?.selectedClincIds ?? 0, providerId: self?.selectedProvidersIds ?? 0, serviceIds: self?.selectedServicesIds ?? [])
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allProviders.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectAppoinmentStatusButtonAction(sender: UIButton) {
        let statusArray = ["Pending", "Confirmed", "Completed", "Canceled", "Updated"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: statusArray, cellType: .subTitle) { (cell, allStatus, indexPath) in
            cell.textLabel?.text = allStatus
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.appoinmentStatusField.text = selectedItem
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(statusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectTimesButtonAction(sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allTimesList, cellType: .subTitle) { (cell, allTimes, indexPath) in
            cell.textLabel?.text = self.eventViewModel?.utcToLocal(dateStr: allTimes)
        }
        
        selectionMenu.setSelectedItems(items: selectedTimes) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.timeTextField.text = self?.eventViewModel?.utcToLocal(dateStr: selectedList[0])
            self?.selectedTime = selectedList[0]
            self?.selectedTimes = selectedList
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allTimesList.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func saveButtonAction(sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
            return
        }
        
        guard let emailValidate = eventViewModel?.isValidEmail(email), emailValidate else {
            emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
            return
        }
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            firstNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
            return
        }
        
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            phoneNumberTextField.showError(message: "Phone Number is required")
            return
        }
        
        let characterCount = phoneNumber.count
        if characterCount < 10 {
            phoneNumberTextField.showError(message: "Phone Number should contain 10 digits")
        }
        
        guard let clinic = clincsTextField.text, !clinic.isEmpty else {
            clincsTextField.showError(message: Constant.Profile.clinicsRequired)
            return
        }
        guard let services = servicesTextField.text, !services.isEmpty else {
            servicesTextField.showError(message: "Services are required")
            return
        }
        guard let provider = providersTextField.text, !provider.isEmpty else {
            providersTextField.showError(message: "Providers are required")
            return
        }
        
        guard let date = dateTextField.text, !date.isEmpty else {
            dateTextField.showError(message: Constant.Profile.chooseToDate)
            return
        }
        
        guard let time = timeTextField.text, !time.isEmpty else {
            timeTextField.showError(message: Constant.Profile.chooseToTime)
            return
        }
        
        let str: String = (date) + " " + (time)
        let scheduledDate = (dateFormater?.convertDateStringToStringCalender(dateString: str)) ?? ""
        
        if self.selectedProvidersIds == 0 {
            self.selectedProvidersIds = self.editBookingHistoryData?.providerId ?? 0
        }
        if self.selectedClincIds == 0 {
            self.selectedClincIds = self.editBookingHistoryData?.clinicId ?? 0
        }
        if self.selectedServicesIds.first == 0 {
            let serviceSelectedArray = self.editBookingHistoryData?.serviceList ?? []
            self.selectedServicesIds = serviceSelectedArray.map({$0.serviceId ?? 0})
        }
        self.view.ShowSpinner()
        eventViewModel?.editAppoinemnetMethod(editAppoinmentId: editBookingHistoryData?.id ?? 0,
                                              editAppoinmentModel: EditAppoinmentModel(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber, notes: notesTextView.text, clinicId: selectedClincIds, serviceIds: selectedServicesIds, providerId: selectedProvidersIds, date: selectedDate, time: convertDateString(dateString: selectedTime), appointmentType: appointmentTypeSelected, source: sourceTypeSelected, appointmentDate: scheduledDate, appointmentConfirmationStatus: appoinmentStatusField.text))
    }
}
