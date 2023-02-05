////
////  AppointmentsViewController.swift
////  Growth99
////
////  Created by admin on 13/11/22.
////
//
//import UIKit
//
//protocol AppointmentsViewContollerProtocol: AnyObject {
//    func errorReceivedAppointments(error: String)
//    func clinicsReceivedAppointments()
//    func serviceListDataRecivedAppointments()
//    func providerListDataRecivedAppointments()
//    func appointmentListDataRecivedAppointments()
//    func appointmentRemovedSuccefully(message: String)
//}
//
//class AppointmentsViewController: UIViewController, AppointmentsViewContollerProtocol, AppointmentsListTableViewCellDelegate {
//    func removeAppointments(cell: AppointmentsTableViewCell, index: IndexPath) {
//
//    }
//
//    func paymentAppointments(cell: AppointmentsTableViewCell, index: IndexPath) {
//
//    }
//
//    func clinicsReceivedAppointments() {
//
//    }
//
//    func serviceListDataRecivedAppointments() {
//
//    }
//
//    func providerListDataRecivedAppointments() {
//
//    }
//
//    @IBOutlet weak var appointmentsTableView: UITableView!
//    @IBOutlet private weak var searchBar: UISearchBar!
//
//    var viewModel: AppointmentsViewModelProtocol?
//    var isSearch : Bool = false
//    var appointmentsFilterData = [AppointmentDTOList]()
//    var appointmentsListData = [AppointmentDTOList]()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.viewModel = AppointmentsViewModel(delegate: self)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
//        setUpNavigationBar()
//    }
//
//    func setUpNavigationBar() {
//        self.title = Constant.Profile.appointmentTrigger
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        addSerchBar()
//        self.getAppointments()
//        self.registerTableView()
//    }
//
//    func registerTableView() {
//        self.appointmentsTableView.delegate = self
//        self.appointmentsTableView.dataSource = self
//        appointmentsTableView.register(UINib(nibName: "AppointmentsTableViewCell", bundle: nil), forCellReuseIdentifier: "AppointmentsTableViewCell")
//    }
//
//    @objc func updateUI() {
//        self.getAppointments()
//        self.view.ShowSpinner()
//    }
//
//    func addSerchBar() {
//        searchBar.searchBarStyle = UISearchBar.Style.default
//        searchBar.placeholder = " Search..."
//        searchBar.sizeToFit()
//        searchBar.isTranslucent = false
//        searchBar.backgroundImage = UIImage()
//        searchBar.delegate = self
//    }
//
//    @objc func LeadList() {
//        self.view.ShowSpinner()
//        self.getAppointments()
//    }
//
//    @objc func getAppointments() {
//        self.view.ShowSpinner()
//        viewModel?.getCalenderInfoListAppointments(clinicId: 0, providerId: 0, serviceId: 0)
//    }
//
//    fileprivate lazy var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        return formatter
//    }()
//
//    func appointmentListDataRecivedAppointments() {
//        self.view.HideSpinner()
//        appointmentsListData = viewModel?.appointmentInfoListDataAppointments ?? []
//        appointmentsListData = AppointmentsListData.sorted(by: { ($0.appointmentCreatedDate ?? "") > ($1.appointmentCreatedDate ?? "")})
//        self.appointmentsTableView.setContentOffset(.zero, animated: true)
//        self.appointmentsTableView.reloadData()
//    }
//
//    func errorReceivedAppointments(error: String) {
//        self.view.HideSpinner()
//        self.view.showToast(message: error)
//    }
//
//    func editAppointment(cell: AppointmentsTableViewCell, index: IndexPath) {
//        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
//        editVC.editAppointmentsData = self.appointmentsListData[index.row]
//        navigationController?.pushViewController(editVC, animated: true)
//    }
//
//    func removeAppointment(cell: AppointmentsTableViewCell, index: IndexPath) {
//        let alert = UIAlertController(title: "Delete Appointment", message: "Are you sure you want to delete", preferredStyle: UIAlertController.Style.alert)
//        //\(cell.PateintDataAtIndex(index: index.row)?.name ?? "")"
//        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
////            self?.view.ShowSpinner()
////            let pateintId = self?.viewModel?.PateintDataAtIndex(index: index.row)?.id ?? 0
////            self?.viewModel?.removePateints(pateintId: pateintId)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func appointmentRemovedSuccefully(message: String) {
//        self.getAppointments()
//    }
//}
//
//extension AppointmentsViewContoller:  UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        appointmentsFilterData = (appointmentsListData.filter { $0.patientFirstName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
//        isSearch = true
//        appointmentsTableView.reloadData()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        isSearch = false
//        searchBar.text = ""
//        appointmentsTableView.reloadData()
//    }*/
//}
