//
//  SocialProfilesViewController.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation
import UIKit
import FBSDKLoginKit

protocol SocialProfilesListViewControllerProtocol: AnyObject {
    func socialProfilesListRecived()
    func linkedSocialProfilesDataRecived()
    func socialProfilesRemovedSuccefully(message: String)
    func errorReceived(error: String)
}

class SocialProfilesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: SocialProfilesListViewModelProtocol?
    var isSearch : Bool = false
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getSocialProfilesData.count ?? 0)
        self.viewModel = SocialProfilesListViewModel(delegate: self)
        self.setBarButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name("AccessTokenReceived"), object: nil)
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        guard let accessToken = notification.userInfo?["accessToken"] as? String else { return }
        guard let socialType = notification.userInfo?["SocialType"] as? String else { return }
        viewModel?.linkSocialProfiles(accessToken: accessToken, socialChannel: socialType)
    }
    
    func registerTableView() {
        self.tableView.register(UINib(nibName: "SocialProfilesListTableViewCell", bundle: nil), forCellReuseIdentifier: "SocialProfilesListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.viewModel?.getSocialProfilesList()
        self.title = Constant.Profile.socialProfiles
    }
    
    func setBarButton(){
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(openSocialPlatform), imageName: "add")
    }
    
    @objc func openSocialPlatform(sender: UIButton) {
        let rolesArray = ["Facebook", "Instagram", "Linkedin"]
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            if text == "Facebook" {
                let detailController = UIStoryboard(name: "SocialWebViewController", bundle: nil).instantiateViewController(withIdentifier: "SocialWebViewController") as! SocialWebViewController
                detailController.userSocialType = "Facebook"
                detailController.userSocialUrl = "https://www.facebook.com/login.php?skip_api_login=1&api_key=641759040281574&kid_directed_site=0&app_id=641759040281574&signed_next=1&next=https%3A%2F%2Fwww.facebook.com%2Fv10.0%2Fdialog%2Foauth%3Fclient_id%3D641759040281574%26redirect_uri%3Dhttps%253A%252F%252Fapp.growth99.com%252Fpost-library%252Ffacebook%252Fcallback%26scope%3Dpages_manage_posts%252Cpages_read_user_content%252Cpages_show_list%26response_type%3Dtoken%26state%3Dchannel_Facebook%26ret%3Dlogin%26fbapp_pres%3D0%26logger_id%3D89a7f94b-f853-498e-85e8-f4a73cb99447%26tp%3Dunspecified&cancel_url=https%3A%2F%2Fapp.growth99.com%2Fpost-library%2Ffacebook%2Fcallback%3Ferror%3Daccess_denied%26error_code%3D200%26error_description%3DPermissions%2Berror%26error_reason%3Duser_denied%26state%3Dchannel_Facebook%23_%3D_&display=page&locale=en_GB&pl_dbl=0"
                self?.navigationController?.pushViewController(detailController, animated: true)
            } else if (text == "Instagram") {
                let detailController = UIStoryboard(name: "SocialWebViewController", bundle: nil).instantiateViewController(withIdentifier: "SocialWebViewController") as! SocialWebViewController
                detailController.userSocialType = "Instagram"
                detailController.userSocialUrl = "https://www.facebook.com/login.php?skip_api_login=1&api_key=641759040281574&kid_directed_site=0&app_id=641759040281574&signed_next=1&next=https%3A%2F%2Fwww.facebook.com%2Fv10.0%2Fdialog%2Foauth%3Fclient_id%3D641759040281574%26redirect_uri%3Dhttps%253A%252F%252Fapp.growth99.com%252Fpost-library%252Ffacebook%252Fcallback%26scope%3Dpages_manage_posts%252Cpages_read_user_content%252Cpages_show_list%26response_type%3Dtoken%26state%3Dchannel_Facebook%26ret%3Dlogin%26fbapp_pres%3D0%26logger_id%3D89a7f94b-f853-498e-85e8-f4a73cb99447%26tp%3Dunspecified&cancel_url=https%3A%2F%2Fapp.growth99.com%2Fpost-library%2Ffacebook%2Fcallback%3Ferror%3Daccess_denied%26error_code%3D200%26error_description%3DPermissions%2Berror%26error_reason%3Duser_denied%26state%3Dchannel_Facebook%23_%3D_&display=page&locale=en_GB&pl_dbl=0"
                self?.navigationController?.pushViewController(detailController, animated: true)
            } else {
                let detailController = UIStoryboard(name: "SocialWebViewController", bundle: nil).instantiateViewController(withIdentifier: "SocialWebViewController") as! SocialWebViewController
                detailController.userSocialType = "Linkedin"
                detailController.userSocialUrl = "https://www.linkedin.com/uas/login?session_redirect=%2Foauth%2Fv2%2Flogin-success%3Fapp_id%3D206460971%26auth_type%3DAC%26flow%3D%257B%2522state%2522%253A%2522123456%2522%252C%2522scope%2522%253A%2522r_liteprofile%252Cr_emailaddress%252Cw_member_social%2522%252C%2522authorizationType%2522%253A%2522OAUTH2_AUTHORIZATION_CODE%2522%252C%2522redirectUri%2522%253A%2522https%253A%252F%252Fapp.growth99.com%252Fpost-library%252Flinkedin%252Fcallback%2522%252C%2522currentStage%2522%253A%2522LOGIN_SUCCESS%2522%252C%2522appId%2522%253A206460971%252C%2522currentSubStage%2522%253A0%252C%2522authFlowName%2522%253A%2522generic-permission-list%2522%252C%2522creationTime%2522%253A1693679279949%257D&fromSignIn=1&trk=oauth&cancel_redirect=%2Foauth%2Fv2%2Flogin-cancel%3Fapp_id%3D206460971%26auth_type%3DAC%26flow%3D%257B%2522state%2522%253A%2522123456%2522%252C%2522scope%2522%253A%2522r_liteprofile%252Cr_emailaddress%252Cw_member_social%2522%252C%2522authorizationType%2522%253A%2522OAUTH2_AUTHORIZATION_CODE%2522%252C%2522redirectUri%2522%253A%2522https%253A%252F%252Fapp.growth99.com%252Fpost-library%252Flinkedin%252Fcallback%2522%252C%2522currentStage%2522%253A%2522LOGIN_SUCCESS%2522%252C%2522appId%2522%253A206460971%252C%2522currentSubStage%2522%253A0%252C%2522authFlowName%2522%253A%2522generic-permission-list%2522%252C%2522creationTime%2522%253A1693679279949%257D"
                self?.navigationController?.pushViewController(detailController, animated: true)
            }
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: 150, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    func addSerchBar(){
        self.searchBar.searchBarStyle = UISearchBar.Style.default
        self.searchBar.placeholder = "Search..."
        self.searchBar.sizeToFit()
        self.searchBar.isTranslucent = false
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
    }
}

extension SocialProfilesListViewController: SocialProfilesListTableViewCellDelegate {
    
    func editSocialProfiles(cell: SocialProfilesListTableViewCell, index: IndexPath) {
        let detailController = UIStoryboard(name: "CreateSocialProfileViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateSocialProfileViewController") as! CreateSocialProfileViewController
        detailController.socialProfilesScreenName = "Edit Screen"
        if self.isSearch {
            detailController.socialProfileId = viewModel?.socialProfilesFilterListDataAtIndex(index: index.row)?.id ?? 0
        } else {
            detailController.socialProfileId = viewModel?.socialProfilesListDataAtIndex(index: index.row)?.id ?? 0
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func removeSocialProfile(cell: SocialProfilesListTableViewCell, index: IndexPath) {
        var tagName : String = ""
        var tagId: Int = 0
        
        if self.isSearch {
            tagId = self.viewModel?.socialProfilesFilterListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.socialProfilesFilterListDataAtIndex(index: index.row)?.name ?? String.blank
        }else{
            tagId = self.viewModel?.socialProfilesListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.socialProfilesListDataAtIndex(index: index.row)?.name ?? String.blank
        }
        
        let alert = UIAlertController(title: "Delete Social Profile", message: "Are you sure you want to delete \n\(tagName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                        handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeSocialProfiles(socialProfilesId: tagId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SocialProfilesListViewController: SocialProfilesListViewControllerProtocol {
    func linkedSocialProfilesDataRecived() {
        self.view.HideSpinner()
        self.viewModel?.getSocialProfilesList()
    }
    
    func socialProfilesListRecived() {
        self.view.HideSpinner()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getSocialProfilesData.count ?? 0)
        self.tableView.reloadData()
    }
    
    func socialProfilesRemovedSuccefully(message: String){
        self.view.showToast(message: message, color: .systemGreen)
        SocialLoginManager.shared.loginManager.logOut()
        viewModel?.getSocialProfilesList()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}
