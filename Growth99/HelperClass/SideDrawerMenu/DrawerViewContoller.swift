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
    let appDel = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet private var scrollViewHight: NSLayoutConstraint!
    @IBOutlet private var scrollview: UIScrollView!
    @IBOutlet private var roles: UILabel!
    @IBOutlet private var bussinessTitile: UILabel!
    @IBOutlet private var profileImage: UIImageView!

    var userInfo: UserInfo?
    var section: Int = 0
    var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.viewModel =  DrawerViewModel(delegate: self)
        self.mainMenuList = viewModel?.loadJson() ?? []
        self.hiddenSections = Set(0...mainMenuList.count)
        self.roles.text = UserRepository.shared.roles
        self.bussinessTitile.text = "Medical"

        scrollview.delegate = self
        
        /// used for show userInfo
        //        self.tableView.register(UINib(nibName: "HeaderViewTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderViewTableViewCell")
        
        /// used for showing menutitle
        self.tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "MenuTableViewCell")
        
        ///used for showing subMenuTitle
        self.tableView.register(UINib(nibName: "SubMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SubMenuTableViewCell")
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
            self.tableView.insertRows(at: indexPathsForSection(), with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(), with: .fade)
        }
        self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
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
        if title == "Logout" {
            UserRepository.shared.isUserLoged =  false
            let LogInVC = UIStoryboard(name: "LogInViewController", bundle: nil).instantiateViewController(withIdentifier: "LogInViewController")
            let mainVcIntial = UINavigationController(rootViewController:  LogInVC)
            mainVcIntial.isNavigationBarHidden = true
            appDel.window?.rootViewController = mainVcIntial
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
            menuCell.forwordArrow.transform = menuCell.forwordArrow.transform.rotated(by: CGFloat.pi/2)
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index:indexPath.section) as IndexSet, with: .fade)
        tableView.endUpdates()
        switch indexPath.row {
        case 0:
            pushViewControllerFromDrawerMenu(pusedViewController: "HomeViewContoller")
            break
        case 1:
            pushViewControllerFromDrawerMenu(pusedViewController: "AppointmentsViewController")
            break
        case 2:
            pushViewControllerFromDrawerMenu(pusedViewController: "WorkingScheduleViewController")
            break
        case 3:
            pushViewControllerFromDrawerMenu(pusedViewController: "VacationScheduleViewController")
            break
        case 4:
            pushViewControllerFromDrawerMenu(pusedViewController: "ChangePasswordViewController")
            break
        default:
            break
        }
        appDel.drawerController.setDrawerState(.closed, animated: true)
    }
    
    func pushViewControllerFromDrawerMenu(pusedViewController: String) {
        let mainViewController = UIStoryboard(name: pusedViewController, bundle: nil).instantiateViewController(withIdentifier: pusedViewController)
        let navController = UINavigationController(rootViewController: mainViewController)
        appDel.drawerController.mainViewController = navController
    }
}
