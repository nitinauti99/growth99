//
//  ServicesListDetailViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 13/01/23.
//

import UIKit
import DropDown

protocol ServicesListDetailViewContollerProtocol {
    func errorReceived(error: String)
    func clinicsRecived()
}

class ServicesListDetailViewController: UIViewController, ServicesListDetailViewContollerProtocol {

    @IBOutlet private weak var serviceNameTextField: CustomTextField!
    @IBOutlet private weak var selectClinicTextField: CustomTextField!
    @IBOutlet private weak var serviceDurationTextField: CustomTextField!
    @IBOutlet private weak var serviceCategoryTextField: CustomTextField!
    @IBOutlet private weak var serviceCostTextField: CustomTextField!
    @IBOutlet private weak var serviceUrlTextField: CustomTextField!
    @IBOutlet private weak var depositCostTextField: CustomTextField!
    @IBOutlet private weak var serviceDescTextView: UITextView!
    @IBOutlet private weak var serviceConsentTextField: CustomTextField!
    @IBOutlet private weak var serviceQuestionarieTextField: CustomTextField!

    let dropDown = DropDown()
    var selectedClincs = [Clinics]()
    var allClinics = [Clinics]()
    var servicesAddViewModel: ServiceListDetailViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupUI()
        servicesAddViewModel = ServiceListDetailModel(delegate: self)
        getClinicInfo()
    }
    
    func getClinicInfo() {
        self.view.ShowSpinner()
        servicesAddViewModel?.getallClinics()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.createService
    }
    
    func setupUI() {
        serviceDescTextView.layer.borderColor = UIColor.gray.cgColor
        serviceDescTextView.layer.borderWidth = 1.0
    }
    
    func clinicsRecived() {
        self.view.HideSpinner()
        allClinics = servicesAddViewModel?.getAllClinicsData ?? []
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
    }
    
    @IBAction func selectClinicButtonAction(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.selectClinicTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.selectClinicTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
//            let selectedId = selectedList.map({$0.id ?? 0})
//            self?.selectedClincIds = selectedId
            self?.selectedClincs  = selectedList
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allClinics.count * 44))), arrowDirection: .up), from: self)
        
    }
    @IBAction func serviceDurationButtonAction(sender: UIButton) {
        let leadStatusArray = ["10", "15", "20", "30", "45", "60", "90", "120", "150", "180"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.serviceDurationTextField.text = selectedItem
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadStatusArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectConsentButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func selectQuestionButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func serviceCategoryButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func enableDepositsButtonAction(sender: UIButton) {
       
    }
    
    @IBAction func disableBookingButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func uploadServiceImageButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func saveServiceButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func cancelServiceButtonAction(sender: UIButton) {
        
    }
}
