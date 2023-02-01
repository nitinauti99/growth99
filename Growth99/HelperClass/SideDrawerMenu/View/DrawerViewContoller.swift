//
//  DrawerViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 05/11/22.
//

import Foundation
import UIKit

protocol DrawerViewContollerProtocol {
    
}

class DrawerViewContoller: UIViewController, SubMenuTableViewCellDelegate, DrawerViewContollerProtocol {
    
    @IBOutlet private var tableView: UITableView!
    private var mainMenuList = [menuList]()
    var viewModel: DrawerViewModelProtocol?
    private var hiddenSections = Set<Int>()
    @IBOutlet private var scrollViewHight: NSLayoutConstraint!
    @IBOutlet private var scrollview: UIScrollView!
    @IBOutlet private var roles: UILabel!
    @IBOutlet private var bussinessTitile: UILabel!
    @IBOutlet private var profileImage: UIImageView!
    let user = UserRepository.shared

    
    // MARK: - DECLARATIONS
    var section: Int = 0
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }
    
    // MARK: - VIEW_METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.viewModel =  DrawerViewModel(delegate: self)
        self.mainMenuList = viewModel?.loadJson() ?? []
        self.hiddenSections = Set(0...mainMenuList.count)
        self.roles.text = UserRepository.shared.roles
        self.profileImage.sd_setImage(with: URL(string: user.bussinessLogo ?? ""), placeholderImage: UIImage(named: "Logo.png"))

        scrollview.delegate = self
        
        self.tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "MenuTableViewCell")
        
        ///used for showing subMenuTitle
        self.tableView.register(UINib(nibName: "SubMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SubMenuTableViewCell")
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bussinessTitile.text = user.bussinessName
    }
    
    // MARK: - FUNCTIONS
    func hideSideMenu() {
        self.view.backgroundColor = .clear
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first!.view == self.view {
            hideSideMenu()
        }
    }
    
    func revealSideMenu() {
        UIApplication.shared.keyWindow?.addSubview(self.view)
        self.view.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
            }
        })
        self.view.layoutIfNeeded()
    }
    
    // MARK: - BUTTON_ACTIONS
    
    @IBAction func signInTapped(_ sender: UIButton) {
    }
    
    @IBAction func logoutMenuTapped(_ sender: UIBarButtonItem) {
        self.hideSideMenu()
    }
    
    private func hideSection(section: Int) {
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            for row in 0..<(self.mainMenuList[section].subMenuList?.count ?? 0) {
                indexPaths.append(IndexPath(row: row,section: section))
            }
            return indexPaths
        }
        self.tableView.beginUpdates()
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.tableView.insertRows(at: indexPathsForSection(), with: .none)
        } else {
            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(), with: .none)
        }
        self.tableView.reloadSections(IndexSet(integer: section), with: .none)
        self.tableView.endUpdates()
        self.tableView.reloadData()
    }
    
    public func tappedSection(cell: MenuTableViewCell, section: Int, title: String) {
        self.hideSection(section: section)
        self.selection(cell: cell,title: title, section: section)
    }
    
    private func selection(cell: MenuTableViewCell, title: String, section: Int) {
        if self.section == section {
            cell.menuTitle.textColor = .red
        }
        if title == Constant.SideMenu.logout {
            UserRepository.shared.isUserLoged =  false
            let LogInVC = UIStoryboard(name: "LogInViewController", bundle: nil).instantiateViewController(withIdentifier: "LogInViewController")
            let mainVcIntial = UINavigationController(rootViewController:  LogInVC)
            mainVcIntial.isNavigationBarHidden = true
            appDel.window?.rootViewController = mainVcIntial
        } else if title == Constant.SideMenu.helpTraining {
            pushViewControllerFromDrawerMenu(identifier: "GRWebViewController", pusedViewController: "GRWebViewController")
        } else if title == Constant.Profile.tasks {
            pushViewControllerFromDrawerMenu(identifier: "TasksListViewController", pusedViewController: "TasksListViewController")
        } else if title == Constant.Profile.triggers {
            pushViewControllerFromDrawerMenu(identifier: "TriggersListViewController", pusedViewController: "TriggersListViewController")
        }
    }
}

extension DrawerViewContoller: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewHight.constant = tableViewHeight + 300
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHight.constant = tableViewHeight + 300
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return mainMenuList.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) {
            return 0
        }
        return  mainMenuList[section].subMenuList?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var menuCell = MenuTableViewCell()
        menuCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        menuCell.forwordArrow.transform = .identity
        if !self.hiddenSections.contains(section) {
            menuCell.forwordArrow.transform = menuCell.forwordArrow.transform.rotated(by: CGFloat.pi)
        }
        menuCell.configure(mainMenuList: self.mainMenuList[section], section: section, delegate: self)
        return menuCell
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SubMenuTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "SubMenuTableViewCell", for: indexPath) as! SubMenuTableViewCell
        cell.configure(titleData: self.mainMenuList[indexPath.section], row: indexPath.row)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index:indexPath.section) as IndexSet, with: .none)
        tableView.endUpdates()
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                pushViewControllerFromDrawerMenu(identifier: "BaseTabbar", pusedViewController: "HomeViewContoller")
                break
            case 1:
                pushViewControllerFromDrawerMenu(identifier: "AppointmentsViewController", pusedViewController: "AppointmentsViewController")
            case 2:
                pushViewControllerFromDrawerMenu(identifier: "WorkingScheduleViewController", pusedViewController: "WorkingScheduleViewController")
            case 3:
                pushViewControllerFromDrawerMenu(identifier: "VacationScheduleViewController", pusedViewController: "VacationScheduleViewController")
            case 4:
                pushViewControllerFromDrawerMenu(identifier: "ChangePasswordViewController", pusedViewController: "ChangePasswordViewController")
                break
            default:
                break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                pushViewControllerFromDrawerMenu(identifier: "BusinessProfileViewController", pusedViewController: "BusinessProfileViewController")
            case 1:
                pushViewControllerFromDrawerMenu(identifier: "ClinicsListViewController", pusedViewController: "ClinicsListViewController")
            case 2:
                pushViewControllerFromDrawerMenu(identifier: "CategoriesListViewController", pusedViewController: "CategoriesListViewController")
            case 3:
                pushViewControllerFromDrawerMenu(identifier: "ServicesListViewController", pusedViewController: "ServicesListViewController")
            case 4:
                pushViewControllerFromDrawerMenu(identifier: "UserListViewContoller", pusedViewController: "UserListViewContoller")
            default:
                break
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 1:
                pushViewControllerFromDrawerMenu(identifier: "BookingHistoryViewController", pusedViewController: "BookingHistoryViewController")
            default:
                break
            }
        } else if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                pushViewControllerFromDrawerMenu(identifier: "PateintListViewContoller", pusedViewController: "PateintListViewContoller")
            case 1:
                pushViewControllerFromDrawerMenu(identifier: "PateintsTagsListViewController", pusedViewController: "PateintsTagsListViewController")
            default:
                break
            }
        }
    }
    
    func pushViewControllerFromDrawerMenu(identifier: String, pusedViewController: String) {
        let mainViewController = UIStoryboard(name: identifier, bundle: Bundle.main).instantiateViewController(withIdentifier: pusedViewController)
        (BaseTabbarViewController.currentInstance?.selectedViewController as? UINavigationController)?.pushViewController(mainViewController, animated: true)
        self.hideSideMenu()
    }
}
