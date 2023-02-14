//
//  ClinicsListDetailViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 12/01/23.
//

import UIKit

protocol ClinicsDetailListVCProtocol: AnyObject {
    func clinicUpdateReceived(responeMessage: String)
    func clinicsDetailsDataReceived()
    func timeZoneListDataRecived()
    func errorReceived(error: String)
}

class ClinicsListDetailViewController: UIViewController, ClinicsDetailListVCProtocol {

    @IBOutlet private weak var clinicNameTextField: CustomTextField!
    @IBOutlet private weak var contactNumberTextField: CustomTextField!
    @IBOutlet private weak var timeZoneTextField: CustomTextField!
    @IBOutlet private weak var addressField: CustomTextField!
    @IBOutlet private weak var aboutClinicTextView: UITextView!

    @IBOutlet private weak var notificationEmailTextField: CustomTextField!
    @IBOutlet private weak var countryCodeTextField: CustomTextField!
    @IBOutlet private weak var notificationSmsTextField: CustomTextField!
    @IBOutlet private weak var currencyTextField: CustomTextField!
    @IBOutlet private weak var websiteURLTextField: CustomTextField!
    @IBOutlet private weak var appointmentURLTextField: CustomTextField!
    @IBOutlet private weak var giftCardTextView: UITextView!

    @IBOutlet private weak var giftcardURLTextField: CustomTextField!
    @IBOutlet private weak var instagramURLTextField: CustomTextField!
    @IBOutlet private weak var twitterURLTextField: CustomTextField!
    @IBOutlet private weak var paymentLinkTextField: CustomTextField!
    
    @IBOutlet private weak var mondayBtn: UIButton!
    @IBOutlet private weak var mondayStartTimeTF: CustomTextField!
    @IBOutlet private weak var mondayEndTimeTF: CustomTextField!

    @IBOutlet private weak var tuesdayBtn: UIButton!
    @IBOutlet private weak var tuesdayStartTimeTF: CustomTextField!
    @IBOutlet private weak var tuesdayEndTimeTF: CustomTextField!

    @IBOutlet private weak var wednesdayBtn: UIButton!
    @IBOutlet private weak var wednesdayStartTimeTF: CustomTextField!
    @IBOutlet private weak var wednesdayEndTimeTF: CustomTextField!

    @IBOutlet private weak var thursdayBtn: UIButton!
    @IBOutlet private weak var thursdayStartTimeTF: CustomTextField!
    @IBOutlet private weak var thursdayEndTimeTF: CustomTextField!

    @IBOutlet private weak var fridayBtn: UIButton!
    @IBOutlet private weak var fridayStartTimeTF: CustomTextField!
    @IBOutlet private weak var fridayEndTimeTF: CustomTextField!

    @IBOutlet private weak var saturdayBtn: UIButton!
    @IBOutlet private weak var saturdayStartTimeTF: CustomTextField!
    @IBOutlet private weak var saturdayEndTimeTF: CustomTextField!

    @IBOutlet private weak var sundayBtn: UIButton!
    @IBOutlet private weak var sundayStartTimeTF: CustomTextField!
    @IBOutlet private weak var sundayEndTimeTF: CustomTextField!

    var clinicId: Int?
    var screenTitle: String = String.blank
    var dateFormater: DateFormaterProtocol?
    var timeZoneList: [String]?
    var viewModel: ClinicsDetailListViewModelProtocol?
    var businessHours = [BusinessHoursAccount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ClinicsDetailListViewModel(delegate: self)
        setUpNavigationBar()
        setupUI()
        dateFormater = DateFormater()
        getSelectedClinicsList()
    }
    
    @objc func getSelectedClinicsList() {
        self.view.ShowSpinner()
        viewModel?.getselectedClinicDetail(clinicId: clinicId ?? 0)
    }

    func setUpNavigationBar() {
        self.title = screenTitle
    }
    
    func setupUI() {
        aboutClinicTextView.layer.borderColor = UIColor.gray.cgColor
        aboutClinicTextView.layer.borderWidth = 1.0
        giftCardTextView.layer.borderColor = UIColor.gray.cgColor
        giftCardTextView.layer.borderWidth = 1.0
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismiss(animated: true)
    }

    
    func clinicUpdateReceived(responeMessage: String) {
        self.view.HideSpinner()
        if responeMessage == Constant.Profile.editClinic {
            self.view.showToast(message: "Clinic details updated sucessfully", color: .black)
        } else {
            self.view.showToast(message: "Clinic created sucessfully", color: .black)
        }
        
    }
    @IBAction func timeZoneSelectionButton(sender: UIButton) {
        if timeZoneList?.count == 0 {
            self.timeZoneTextField.text = ""
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: timeZoneList ?? [], cellType: .subTitle) { (cell, alltimezone, indexPath) in
            cell.textLabel?.text = alltimezone.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.timeZoneTextField.text = selectedItem
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double((timeZoneList?.count ?? 0) * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func countrySelectionButton(sender: UIButton) {
        
    }
    
    @IBAction func currencySelectionButton(sender: UIButton) {
        let currencyArray = ["USD", "GBP", "CAD", "EUR", "JPY", "CHF", "ZAR", "AUD", "NZD"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: currencyArray, cellType: .subTitle) { (cell, allCurrency, indexPath) in
            cell.textLabel?.text = allCurrency.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.currencyTextField.text = selectedItem
         }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(currencyArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func clinicsDetailsDataReceived() {
        viewModel?.getTimeZonesList()
    }
    
    func timeZoneListDataRecived() {
        self.view.HideSpinner()
        timeZoneList = viewModel?.getTimeZonesListData
        if screenTitle == Constant.Profile.editClinic {
            setupClinicDetailUI()
        }
    }
    
    func setupClinicDetailUI() {
        clinicNameTextField.text = viewModel?.getClinicsListData?.name ?? String.blank
        contactNumberTextField.text = viewModel?.getClinicsListData?.contactNumber ?? String.blank
        timeZoneTextField.text = viewModel?.getClinicsListData?.timezone ?? String.blank
        addressField.text = viewModel?.getClinicsListData?.address ?? String.blank
        aboutClinicTextView.text = viewModel?.getClinicsListData?.about ?? String.blank
        notificationEmailTextField.text = viewModel?.getClinicsListData?.notificationEmail ?? String.blank
        countryCodeTextField.text = viewModel?.getClinicsListData?.countryCode ?? String.blank
        notificationSmsTextField.text = viewModel?.getClinicsListData?.notificationSMS ?? String.blank
        currencyTextField.text = viewModel?.getClinicsListData?.currency ?? String.blank
        websiteURLTextField.text = viewModel?.getClinicsListData?.website ?? String.blank
        appointmentURLTextField.text = viewModel?.getClinicsListData?.appointmentUrl ?? String.blank
        giftCardTextView.text = viewModel?.getClinicsListData?.giftCardDetail ?? String.blank
        giftcardURLTextField.text = viewModel?.getClinicsListData?.giftCardUrl ?? String.blank
        instagramURLTextField.text = viewModel?.getClinicsListData?.instagram ?? String.blank
        twitterURLTextField.text = viewModel?.getClinicsListData?.twitter ?? String.blank
        paymentLinkTextField.text = viewModel?.getClinicsListData?.paymentLink ?? String.blank
        
        
        let filteredMondayArray = viewModel?.getClinicsListData?.businessHours?.filter{$0.dayOfWeek == "MONDAY"}
        if filteredMondayArray?.count == 0 {
            mondayBtn.isSelected = false
            mondayStartTimeTF.text = String.blank
            mondayEndTimeTF.text = String.blank
        } else {
            mondayBtn.isSelected = true
            mondayStartTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredMondayArray?.first?.openHour ?? String.blank)
            mondayEndTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredMondayArray?.first?.closeHour ?? String.blank)
        }
        
        let filteredTuesdayArray = viewModel?.getClinicsListData?.businessHours?.filter{$0.dayOfWeek == "TUESDAY"}
        if filteredTuesdayArray?.count == 0 {
            tuesdayBtn.isSelected = false
            tuesdayStartTimeTF.text = String.blank
            tuesdayEndTimeTF.text = String.blank
        } else {
            tuesdayBtn.isSelected = true
            tuesdayStartTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredTuesdayArray?.first?.openHour ?? String.blank)
            tuesdayEndTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredTuesdayArray?.first?.closeHour ?? String.blank)
        }

        let filteredWednesdayArray = viewModel?.getClinicsListData?.businessHours?.filter{$0.dayOfWeek == "WEDNESDAY"}
        if filteredWednesdayArray?.count == 0 {
            wednesdayBtn.isSelected = false
            wednesdayStartTimeTF.text = String.blank
            wednesdayEndTimeTF.text = String.blank
        } else {
            wednesdayBtn.isSelected = true
            wednesdayStartTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredWednesdayArray?.first?.openHour ?? String.blank)
            wednesdayEndTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredWednesdayArray?.first?.closeHour ?? String.blank)
        }
        
        let filteredThursdayArray = viewModel?.getClinicsListData?.businessHours?.filter{$0.dayOfWeek == "THURSDAY"}
        if filteredThursdayArray?.count == 0 {
            thursdayBtn.isSelected = false
            thursdayStartTimeTF.text = String.blank
            thursdayEndTimeTF.text = String.blank
        } else {
            thursdayBtn.isSelected = true
            thursdayStartTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredThursdayArray?.first?.openHour ?? String.blank)
            thursdayEndTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredThursdayArray?.first?.closeHour ?? String.blank)
        }
        
        let filteredFridayArray = viewModel?.getClinicsListData?.businessHours?.filter{$0.dayOfWeek == "FRIDAY"}
        if filteredFridayArray?.count == 0 {
            fridayBtn.isSelected = false
            fridayStartTimeTF.text = String.blank
            fridayEndTimeTF.text = String.blank
        } else {
            fridayBtn.isSelected = true
            fridayStartTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredFridayArray?.first?.openHour ?? String.blank)
            fridayEndTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredFridayArray?.first?.closeHour ?? String.blank)
        }
        
        let filteredSaturdayArray = viewModel?.getClinicsListData?.businessHours?.filter{$0.dayOfWeek == "SATURDAY"}
        if filteredSaturdayArray?.count == 0 {
            saturdayBtn.isSelected = false
            saturdayStartTimeTF.text = String.blank
            saturdayEndTimeTF.text = String.blank
        } else {
            saturdayBtn.isSelected = true
            saturdayStartTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredSaturdayArray?.first?.openHour ?? String.blank)
            saturdayEndTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredSaturdayArray?.first?.closeHour ?? String.blank)
        }
        
        let filteredSundayArray = viewModel?.getClinicsListData?.businessHours?.filter{$0.dayOfWeek == "SUNDAY"}
        if filteredSundayArray?.count == 0 {
            sundayBtn.isSelected = false
            sundayStartTimeTF.text = String.blank
            sundayEndTimeTF.text = String.blank
        } else {
            sundayBtn.isSelected = true
            sundayStartTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredSundayArray?.first?.openHour ?? String.blank)
            sundayEndTimeTF.text = dateFormater?.utcToLocalAccounts(timeString: filteredSundayArray?.first?.closeHour ?? String.blank)
        }
        
    }
    
    func errorReceived(error: String) {
        
    }
    
    @IBAction func mondaySelectionButton(sender: UIButton) {
        mondayBtn.isSelected = !mondayBtn.isSelected
    }
    
    @IBAction func tuesdaySelectionButton(sender: UIButton) {
        tuesdayBtn.isSelected = !tuesdayBtn.isSelected
    }
    
    @IBAction func wednesSelectionButton(sender: UIButton) {
        wednesdayBtn.isSelected = !wednesdayBtn.isSelected
    }
    
    @IBAction func thursdaySelectionButton(sender: UIButton) {
        thursdayBtn.isSelected = !thursdayBtn.isSelected
    }
    
    @IBAction func fridaySelectionButton(sender: UIButton) {
        fridayBtn.isSelected = !fridayBtn.isSelected
    }
    
    @IBAction func saturdaySelectionButton(sender: UIButton) {
        saturdayBtn.isSelected = !saturdayBtn.isSelected
    }
    
    @IBAction func sundaySelectionButton(sender: UIButton) {
        sundayBtn.isSelected = !sundayBtn.isSelected
    }
    
    @IBAction func saveButton(sender: UIButton) {
        guard let clinicName = clinicNameTextField.text, !clinicName.isEmpty else {
            clinicNameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let contactNumber = contactNumberTextField.text, !contactNumber.isEmpty else {
            contactNumberTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let timeZone = timeZoneTextField.text, !timeZone.isEmpty else {
            timeZoneTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let address = addressField.text, !address.isEmpty else {
            addressField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let notificationEmail = notificationEmailTextField.text, !notificationEmail.isEmpty else {
            notificationEmailTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let countryCode = countryCodeTextField.text, !countryCode.isEmpty else {
            countryCodeTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let currency = currencyTextField.text, !currency.isEmpty else {
            currencyTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        if mondayBtn.isSelected {
//            businessHours.append(BusinessHoursAccount(dayOfWeek: "MOMDAY", openHour: <#T##String?#>, closeHour: <#T##String?#>))

        }
        
//        self.view.ShowSpinner()
//        viewModel?.updateUserSelectedClinic()
    }
    
}
