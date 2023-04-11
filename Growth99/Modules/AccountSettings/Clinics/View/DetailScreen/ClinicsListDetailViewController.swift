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

class ClinicsListDetailViewController: UIViewController, ClinicsDetailListVCProtocol, UITextViewDelegate {
    
    @IBOutlet weak var clinicNameTextField: CustomTextField!
    @IBOutlet weak var contactNumberTextField: CustomTextField!
    @IBOutlet weak var timeZoneTextField: CustomTextField!
    @IBOutlet weak var addressField: CustomTextField!
    @IBOutlet weak var aboutClinicTextView: UITextView!
    
    @IBOutlet weak var notificationEmailTextField: CustomTextField!
    @IBOutlet weak var countryCodeTextField: CustomTextField!
    @IBOutlet weak var notificationSmsTextField: CustomTextField!
    @IBOutlet weak var currencyTextField: CustomTextField!
    @IBOutlet weak var websiteURLTextField: CustomTextField!
    @IBOutlet weak var appointmentURLTextField: CustomTextField!
    @IBOutlet weak var giftCardTextView: UITextView!
    
    @IBOutlet weak var giftcardURLTextField: CustomTextField!
    @IBOutlet weak var instagramURLTextField: CustomTextField!
    @IBOutlet weak var twitterURLTextField: CustomTextField!
    @IBOutlet weak var paymentLinkTextField: CustomTextField!
    
    @IBOutlet weak var mondayBtn: UIButton!
    @IBOutlet weak var mondayStartTimeTF: CustomTextField!
    @IBOutlet weak var mondayEndTimeTF: CustomTextField!
    
    @IBOutlet weak var tuesdayBtn: UIButton!
    @IBOutlet weak var tuesdayStartTimeTF: CustomTextField!
    @IBOutlet weak var tuesdayEndTimeTF: CustomTextField!
    
    @IBOutlet weak var wednesdayBtn: UIButton!
    @IBOutlet weak var wednesdayStartTimeTF: CustomTextField!
    @IBOutlet weak var wednesdayEndTimeTF: CustomTextField!
    
    @IBOutlet weak var thursdayBtn: UIButton!
    @IBOutlet weak var thursdayStartTimeTF: CustomTextField!
    @IBOutlet weak var thursdayEndTimeTF: CustomTextField!
    
    @IBOutlet weak var fridayBtn: UIButton!
    @IBOutlet weak var fridayStartTimeTF: CustomTextField!
    @IBOutlet weak var fridayEndTimeTF: CustomTextField!
    
    @IBOutlet weak var saturdayBtn: UIButton!
    @IBOutlet weak var saturdayStartTimeTF: CustomTextField!
    @IBOutlet weak var saturdayEndTimeTF: CustomTextField!
    
    @IBOutlet weak var sundayBtn: UIButton!
    @IBOutlet weak var sundayStartTimeTF: CustomTextField!
    @IBOutlet weak var sundayEndTimeTF: CustomTextField!
    
    @IBOutlet weak var onlineLinkWithoutURLView: UIView!
    @IBOutlet weak var onlineLinkWithURLView: UIView!
    @IBOutlet weak var onlineLinkWithURLTextView: UITextView!
    
    var clinicId: Int?
    var screenTitle: String = String.blank
    var dateFormater: DateFormaterProtocol?
    var timeZoneList: [String]?
    var viewModel: ClinicsDetailListViewModelProtocol?
    var businessHours = [BusinessHoursAccount]()
    var httpMethodType: HTTPMethod = .POST
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ClinicsDetailListViewModel(delegate: self)
        setUpNavigationBar()
        setupUI()
        dateFormater = DateFormater()
        getSelectedClinicsList()
        
        mondayStartTimeTF.tintColor = .clear
        mondayEndTimeTF.tintColor = .clear
        tuesdayStartTimeTF.tintColor = .clear
        tuesdayEndTimeTF.tintColor = .clear
        wednesdayStartTimeTF.tintColor = .clear
        wednesdayEndTimeTF.tintColor = .clear
        thursdayStartTimeTF.tintColor = .clear
        thursdayEndTimeTF.tintColor = .clear
        fridayStartTimeTF.tintColor = .clear
        fridayEndTimeTF.tintColor = .clear
        saturdayStartTimeTF.tintColor = .clear
        saturdayEndTimeTF.tintColor = .clear
        sundayStartTimeTF.tintColor = .clear
        sundayEndTimeTF.tintColor = .clear
        
        mondayStartTimeTF.addInputViewDatePicker(target: self, selector: #selector(mondayStartTimeButtonPressed), mode: .time)
        mondayEndTimeTF.addInputViewDatePicker(target: self, selector: #selector(mondayEndTimeButtonPressed), mode: .time)
        tuesdayStartTimeTF.addInputViewDatePicker(target: self, selector: #selector(tuesdayStartTimeButtonPressed), mode: .time)
        tuesdayEndTimeTF.addInputViewDatePicker(target: self, selector: #selector(tuesdayEndTimeButtonPressed), mode: .time)
        wednesdayStartTimeTF.addInputViewDatePicker(target: self, selector: #selector(wednesdayStartTimeButtonPressed), mode: .time)
        wednesdayEndTimeTF.addInputViewDatePicker(target: self, selector: #selector(wednesdayEndTimeButtonPressed), mode: .time)
        thursdayStartTimeTF.addInputViewDatePicker(target: self, selector: #selector(thursdayStartTimeButtonPressed), mode: .time)
        thursdayEndTimeTF.addInputViewDatePicker(target: self, selector: #selector(thursEndTimeButtonPressed), mode: .time)
        fridayStartTimeTF.addInputViewDatePicker(target: self, selector: #selector(fridayStartTimeButtonPressed), mode: .time)
        fridayEndTimeTF.addInputViewDatePicker(target: self, selector: #selector(tridayEndTimeButtonPressed), mode: .time)
        saturdayStartTimeTF.addInputViewDatePicker(target: self, selector: #selector(saturdayStartTimeButtonPressed), mode: .time)
        saturdayEndTimeTF.addInputViewDatePicker(target: self, selector: #selector(saturdaydayEndTimeButtonPressed), mode: .time)
        sundayStartTimeTF.addInputViewDatePicker(target: self, selector: #selector(sundayStartTimeButtonPressed), mode: .time)
        sundayEndTimeTF.addInputViewDatePicker(target: self, selector: #selector(sundayEndTimeButtonPressed), mode: .time)
    }
    
    @objc func mondayStartTimeButtonPressed() {
        mondayStartTimeTF.text = dateFormater?.timeFormatterString(textField: mondayStartTimeTF)
    }
    
    @objc func mondayEndTimeButtonPressed() {
        mondayEndTimeTF.text = dateFormater?.timeFormatterString(textField: mondayEndTimeTF)
    }
    @objc func tuesdayStartTimeButtonPressed() {
        tuesdayStartTimeTF.text = dateFormater?.timeFormatterString(textField: tuesdayStartTimeTF)
    }
    @objc func tuesdayEndTimeButtonPressed() {
        tuesdayEndTimeTF.text = dateFormater?.timeFormatterString(textField: tuesdayEndTimeTF)
    }
    
    @objc func wednesdayStartTimeButtonPressed() {
        wednesdayStartTimeTF.text = dateFormater?.timeFormatterString(textField: wednesdayStartTimeTF)
    }
    
    @objc func wednesdayEndTimeButtonPressed() {
        wednesdayEndTimeTF.text = dateFormater?.timeFormatterString(textField: wednesdayEndTimeTF)
    }
    
    @objc func thursdayStartTimeButtonPressed() {
        thursdayStartTimeTF.text = dateFormater?.timeFormatterString(textField: thursdayStartTimeTF)
    }
    
    @objc func thursEndTimeButtonPressed() {
        thursdayEndTimeTF.text = dateFormater?.timeFormatterString(textField: thursdayEndTimeTF)
    }
    
    @objc func fridayStartTimeButtonPressed() {
        fridayStartTimeTF.text = dateFormater?.timeFormatterString(textField: fridayStartTimeTF)
    }
    
    @objc func tridayEndTimeButtonPressed() {
        fridayEndTimeTF.text = dateFormater?.timeFormatterString(textField: fridayEndTimeTF)
    }
    
    @objc func saturdayStartTimeButtonPressed() {
        saturdayStartTimeTF.text = dateFormater?.timeFormatterString(textField: saturdayStartTimeTF)
    }
    
    @objc func saturdaydayEndTimeButtonPressed() {
        saturdayEndTimeTF.text = dateFormater?.timeFormatterString(textField: saturdayEndTimeTF)
    }
    
    @objc func sundayStartTimeButtonPressed() {
        sundayStartTimeTF.text = dateFormater?.timeFormatterString(textField: sundayStartTimeTF)
    }
    
    @objc func sundayEndTimeButtonPressed() {
        sundayEndTimeTF.text = dateFormater?.timeFormatterString(textField: sundayEndTimeTF)
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
        self.navigationController?.popViewController(animated: true)
    }
    
    func clinicUpdateReceived(responeMessage: String) {
        self.view.HideSpinner()
        if responeMessage == Constant.Profile.editClinic {
            self.view.showToast(message: "Clinic details updated sucessfully", color: UIColor().successMessageColor())
        } else {
            self.view.showToast(message: "Clinic created sucessfully", color: UIColor().successMessageColor())
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
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
        startPicker()
    }
    
    func startPicker() {
        let countryPicker = CountryPickerViewController()
        countryPicker.title = "Select Country Code"
        countryPicker.selectedCountry = "US"
        countryPicker.delegate = self
        self.present(countryPicker, animated: true)
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
            onlineLinkWithoutURLView.isHidden = true
            onlineLinkWithURLView.isHidden = false
        } else {
            onlineLinkWithoutURLView.isHidden = false
            onlineLinkWithURLView.isHidden = true
        }
    }
    
    func setupClinicDetailUI() {
        clinicNameTextField.text = viewModel?.getClinicsListData?.name ?? String.blank
        
        contactNumberTextField.text = viewModel?.getClinicsListData?.contactNumber?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        
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
        
        let tenentID = UserRepository.shared.Xtenantid ?? String.blank
        let clinicURL = "https://app.growth99.com/ap-booking?b=\(tenentID)&c=\(clinicId ?? 0)"
        onlineLinkWithURLTextView.text = clinicURL
        
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
        
        countryCodeTextField.text = "1"
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
            notificationEmailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
            return
        }
        
        guard let notificationEmailValid = viewModel?.isValidEmail(notificationEmail), notificationEmailValid else {
            notificationEmailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
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
            businessHours.append(BusinessHoursAccount(dayOfWeek: "MONDAY", openHour: dateFormater?.localToServerWithDate(date: mondayStartTimeTF.text ?? String.blank), closeHour: dateFormater?.localToServerWithDate(date: mondayEndTimeTF.text ?? String.blank)))
        }
        
        if tuesdayBtn.isSelected {
            businessHours.append(BusinessHoursAccount(dayOfWeek: "TUESDAY", openHour: dateFormater?.localToServerWithDate(date: tuesdayStartTimeTF.text ?? String.blank), closeHour: dateFormater?.localToServerWithDate(date: tuesdayEndTimeTF.text ?? String.blank)))
        }
        
        if wednesdayBtn.isSelected {
            businessHours.append(BusinessHoursAccount(dayOfWeek: "WEDNESDAY", openHour: dateFormater?.localToServerWithDate(date: wednesdayStartTimeTF.text ?? String.blank), closeHour: dateFormater?.localToServerWithDate(date: wednesdayEndTimeTF.text ?? String.blank)))
        }
        
        if thursdayBtn.isSelected {
            businessHours.append(BusinessHoursAccount(dayOfWeek: "THURSDAY", openHour: dateFormater?.localToServerWithDate(date: thursdayStartTimeTF.text ?? String.blank), closeHour: dateFormater?.localToServerWithDate(date: thursdayEndTimeTF.text ?? String.blank)))
        }
        
        if fridayBtn.isSelected {
            businessHours.append(BusinessHoursAccount(dayOfWeek: "FRIDAY", openHour: dateFormater?.localToServerWithDate(date: fridayStartTimeTF.text ?? String.blank), closeHour: dateFormater?.localToServerWithDate(date: fridayEndTimeTF.text ?? String.blank)))
        }
        
        if saturdayBtn.isSelected {
            businessHours.append(BusinessHoursAccount(dayOfWeek: "SATURDAY", openHour: dateFormater?.localToServerWithDate(date: saturdayStartTimeTF.text ?? String.blank), closeHour: dateFormater?.localToServerWithDate(date: saturdayEndTimeTF.text ?? String.blank)))
        }
        
        if sundayBtn.isSelected {
            businessHours.append(BusinessHoursAccount(dayOfWeek: "SUNDAY", openHour: dateFormater?.localToServerWithDate(date: sundayStartTimeTF.text ?? String.blank), closeHour: dateFormater?.localToServerWithDate(date: sundayEndTimeTF.text ?? String.blank)))
        }
        
        let params = ClinicParamModel(name: clinicName, contactNumber: contactNumber, address: address, notificationEmail: notificationEmail, notificationSMS: notificationSmsTextField.text, timezone: timeZone, isDefault: false, about: aboutClinicTextView.text, facebook: "", instagram: instagramURLTextField.text, twitter: twitterURLTextField.text, giftCardDetail: giftCardTextView.text, giftCardUrl: giftcardURLTextField.text, website: websiteURLTextField.text, paymentLink: paymentLinkTextField.text, appointmentUrl: appointmentURLTextField.text, countryCode: countryCode, currency: currency, googleMyBusiness: "", googlePlaceId: "", yelpUrl: "", businessHours: businessHours, clinicUrl: "")
        let parameters: [String: Any]  = params.toDict()
        
        if self.title == Constant.Profile.createClinic {
            httpMethodType = .POST
        } else {
            httpMethodType = .PUT
        }
        
        self.view.ShowSpinner()
        viewModel?.updateUserSelectedClinic(clinicParms: parameters, clinicId: clinicId ?? 0 , urlMethod: httpMethodType, screenTitle: self.title ?? String.blank)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == onlineLinkWithURLTextView.text) {
            guard let webView = UIViewController.loadStoryboard("GRWebViewController", "GRWebViewController") as? GRWebViewController else {
                fatalError("Failed to load BaseTabbarViewController from storyboard.")
            }
            webView.webViewUrl = URL
            webView.webViewTitle = self.title ?? String.blank
            self.navigationController?.pushViewController(webView, animated: true)
        }
        return false
    }
}

extension ClinicsListDetailViewController: CountryPickerDelegate {
    func countryPicker(didSelect country: Country) {
        countryCodeTextField.text = country.phoneCode
    }
}
