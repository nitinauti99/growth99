//
//  CategoriesAddViewController.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol CategoriesAddViewContollerProtocol {
    func errorReceived(error: String)
    func clinicsRecived()
    func addCategoriesResponse()
    func categoriesResponseReceived()
    func addCategoriesDataRecived()
    func updatedCategoriesResponse()
}

class CategoriesAddViewController: UIViewController, CategoriesAddViewContollerProtocol, UITextFieldDelegate {
    
    @IBOutlet private weak var clincsTextField: CustomTextField!
    @IBOutlet private weak var categoriesNameTextField: CustomTextField!
    @IBOutlet private weak var submitButton: UIButton!

    var allClinics = [Clinics]()
    
    var selectedClincs = [Clinics]()
    var selectedClincIds = [Int]()
    var allCategoriesName = [String]()
    
    var categoriesAddViewModel: CategoriesAddEditViewModelProtocol?
    var screenTitle: String = Constant.Profile.addCategories
    var categoryName: String = String.blank
    var categoryId: Int?
    var userClinics = [ClinicsServices]()
    var isValidationSucess: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesAddViewModel = CategoriesAddEditViewModel(delegate: self)
        setUpNavigationBar()
        getAddCategoriesListInfo()
    }
    
    func setUpNavigationBar() {
        self.title = screenTitle
    }
    
    func getAddCategoriesListInfo() {
        self.view.ShowSpinner()
        categoriesAddViewModel?.getAddCategoriesList()
    }
    
    func addCategoriesDataRecived() {
        categoriesAddViewModel?.getallClinics()
    }
    
    func clinicsRecived() {
        self.view.HideSpinner()
        allClinics = categoriesAddViewModel?.getAllClinicsData ?? []
        setupUI()
    }
    
    func setupUI() {
        if title == Constant.Profile.editCategories {
            self.view.ShowSpinner()
            categoriesAddViewModel?.getCategoriesInfo(categoryId: categoryId ?? 0)
        } else {
            categoriesNameTextField.text = String.blank
            clincsTextField.text = String.blank
        }
    }
    
    func categoriesResponseReceived() {
        self.view.HideSpinner()
        setupCategoriesEditUI()
    }
    
    func setupCategoriesEditUI() {
        categoriesNameTextField.text = categoriesAddViewModel?.getAllCategoriesData?.name
        userClinics = categoriesAddViewModel?.getAllCategoriesData?.clinics ?? []
        clincsTextField.text = userClinics.map({$0.clinic?.name ?? String.blank}).joined(separator: ", ")

        for item in userClinics {
            selectedClincs.append(Clinics(isDefault: item.clinic?.isDefault, name: item.clinic?.name, id: item.clinic?.id, timeZone: ""))
            selectedClincIds.append(item.clinic?.id ?? 0)
        }
    }
    
    func addCategoriesResponse() {
        self.view.HideSpinner()
        self.view.showToast(message: Constant.Profile.addCategorie, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updatedCategoriesResponse() {
        self.view.HideSpinner()
        self.view.showToast(message: "Category updated successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    @IBAction func clinincsDropDown(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.clincsTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.clincsTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedClincIds = selectedId
            self?.selectedClincs  = selectedList
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allClinics.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func saveButtonAction(sender: UIButton) {
        guard let clincsText = clincsTextField.text, !clincsText.isEmpty else {
            clincsTextField.showError(message: Constant.Profile.clinicsRequired)
            return
        }
        
        guard let categoriesName = categoriesNameTextField.text, !categoriesName.isEmpty else {
            categoriesNameTextField.showError(message: Constant.Profile.categoryNameRequired)
            return
        }
        
        guard let categoriesNameContain = categoriesAddViewModel?.getAddCategoriesListData.contains(where: { $0.name == categoriesName }), !categoriesNameContain else {
            categoriesNameTextField.showError(message: "Category with this name already present.")
            return
        }
        
        if selectedClincIds.count == 0 {
            for clinicId in selectedClincs {
                selectedClincIds.append(clinicId.id ?? 0)
            }
        }
        self.view.ShowSpinner()
        let params: [String : Any] = ["name": categoriesNameTextField.text ?? String.blank, "clinicIds": selectedClincIds]
        if title == Constant.Profile.editCategories {
            categoriesAddViewModel?.editCategories(addCategoriesParams: params, selectedCategorieId: categoryId ?? 0)
        } else {
            categoriesAddViewModel?.createCategories(addCategoriesParams: params)
        }
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == categoriesNameTextField {
            guard let categoriesName = categoriesNameTextField.text, !categoriesName.isEmpty else {
                categoriesNameTextField.showError(message: Constant.Profile.categoryNameRequired)
                submitButton.isEnabled = false // Disable the submit button
                return
            }
            submitButton.isEnabled = true // Disable the submit button
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoriesNameTextField {
            guard let textField = categoriesNameTextField.text, !textField.isEmpty else {
                categoriesNameTextField.showError(message: Constant.Profile.categoryNameRequired)
                return
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = Int()
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == categoriesNameTextField {
            maxLength = 30
            categoriesNameTextField.hideError()
            return newString.length <= maxLength
        }
        return true
    }
}
