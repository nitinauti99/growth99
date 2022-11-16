//
//  SidemenuController.swift
//  Dentsply Sirona
//
//  Created by sravangoud on 04/08/20.
//  Copyright © 2020 techouts. All rights reserved.
//
import UIKit

class SidemenuController: UIViewController {

    // MARK: - IBOUTLETS

    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var colSidemenu: UICollectionView!
    @IBOutlet weak var aulaSeparator: UIView!

    @IBOutlet weak var selectedPracticeLabel: UILabel!
    @IBOutlet weak var selectonPracticeButton: UIButton!
    @IBOutlet weak var listExpandHeightConstraint: NSLayoutConstraint!

    // MARK: - DECLARATIONS

    var sideMenuDataArr = [String]()
    var menuSelection: [Int] = []
    var listSelection: Bool = false
    var viewModel: DS_SideMenuViewModel = DS_SideMenuViewModel()

    // MARK: - VIEW_METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        colSidemenu.register(UINib(nibName: "MenuCVCell", bundle: nil), forCellWithReuseIdentifier: "MenuCVCell")
        getDataDropDown()
        // Do any additional setup after loading the view.
    }

    func getDataDropDown() {
        viewModel.getuserRolesPractices { (response, error, _) in
            if error == nil && response != nil {
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        let username = UserDefaults.standard.string(forKey: "UserName") ?? "-"
        let practiceName = UserDefaults.standard.string(forKey: "PracticeUnitName") ?? "-"

        sideMenuDataArr = ["Home", "Orders", "Favorite Products"]
    }

    override func viewDidLayoutSubviews() {

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
        self.view.backgroundColor = .clear
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

    @IBAction func selectPracticeButton(_ sender: UIButton) {
        // need to work this logic
        if listSelection == true {
            listSelection = false
            self.listExpandHeightConstraint.constant = 30
            self.aulaSeparator.backgroundColor = .clear
        } else {
            self.aulaSeparator.backgroundColor = .black
            self.listExpandHeightConstraint.constant = 115
            listSelection = true
        }
    }
}

extension SidemenuController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sideMenuDataArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = colSidemenu.dequeueReusableCell(withReuseIdentifier: "MenuCVCell", for: indexPath) as? MenuCVCell else { fatalError("Unexpected Error") }
        cell.lblTitle.text = sideMenuDataArr[indexPath.item]
        cell.lblTitle.textColor = UIColor.black
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.hideSideMenu()
        } else if indexPath.row == 1 {
            self.hideSideMenu()
        } else if indexPath.row == 2 {
            self.hideSideMenu()

        } else {
        }

    }

    @IBAction func logoutAction(_ sender: Any) {
        showAlert(title: "", message: "Are you sure want to logout?", vc: self)
    }

    @IBAction func aboutUSAction(_ sender: UIButton) {
        guard let url = URL(string: "https://www.dentsplysirona.com/en-us/about/mission-vision.html") else {
            return
        }
        UIApplication.shared.open(url)
    }

    @IBAction func termAction(_ sender: UIButton) {
   
    }
    @IBAction func contactUSAction(_ sender: Any) {
        self.hideSideMenu()
    }

    func showAlert(title: String, message: String, vc: UIViewController) {
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: colSidemenu.bounds.width, height: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colSidemenu.bounds.size.width, height: 40.0)
    }

}

extension String {
    public func getAcronyms(separator: String = "") -> String {
        let acronyms = self.components(separatedBy: " ").map({ String($0.first!) }).joined(separator: separator)
        return acronyms
    }
}
