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
}

class CategoriesAddViewController: UIViewController, CategoriesAddViewContollerProtocol {
    
    @IBOutlet private weak var clincsTextField: CustomTextField!
    @IBOutlet private weak var categoriesNameTextField: CustomTextField!
    
    var allClinics = [Clinics]()
    var selectedClincs = [Clinics]()
    var selectedClincIds = [Int]()
    var categoriesAddViewModel: CategoriesAddEditViewModelProtocol?
    var screenTitle: String = Constant.Profile.addCategories
    var categoryName: String = String.blank
    var clinicName: String = String.blank

    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesAddViewModel = CategoriesAddEditViewModel(delegate: self)
        setUpNavigationBar()
        setupUI()
        getClinicInfo()
    }
    
    func setUpNavigationBar() {
        self.title = screenTitle
    }
    
    func setupUI() {
        if title == Constant.Profile.editCategories {
            categoriesNameTextField.text = categoryName
        } else {
            categoriesNameTextField.text = String.blank
        }
    }
    
    func getClinicInfo() {
        self.view.ShowSpinner()
        categoriesAddViewModel?.getallClinics()
    }
    
    func clinicsRecived() {
        self.view.HideSpinner()
        allClinics = categoriesAddViewModel?.getAllClinicsData ?? []
    }
    
    func addCategoriesResponse() {
        self.view.HideSpinner()
        self.view.showToast(message: Constant.Profile.addCategorie, color: .black)
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    @IBAction func clinincsDropDown(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.clincsTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.clincsTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
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
        guard let dateFrom = clincsTextField.text, !dateFrom.isEmpty else {
            clincsTextField.showError(message: Constant.Profile.clinicsRequired)
            return
        }
        
        guard let dateTo = categoriesNameTextField.text, !dateTo.isEmpty else {
            categoriesNameTextField.showError(message: Constant.Profile.categoryNameRequired)
            return
        }
        self.view.ShowSpinner()
        let params: [String : Any] = ["name": categoriesNameTextField.text ?? String.blank, "clinicIds": selectedClincIds]
        categoriesAddViewModel?.createCategories(addCategoriesParams: params)
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
