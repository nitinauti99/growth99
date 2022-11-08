//
//  menuData.swift
//  Growth99
//
//  Created by nitin auti on 06/11/22.
//

import Foundation

struct MenuModel: Decodable {
    var menuList: [menuList]
}
struct menuList : Decodable {
    let title: String?
    let imageName: String?
    let subMenuList: [SubMenu]?
    var isOpened: Bool?
}

struct SubMenu: Decodable {
    let title: String?
    let imageName: String?
}


struct UserInfo {
    let title: String?
    let imageName: String?
    let bussinessTitle: String?
    init(title: String?, imageName: String?, bussinessTitle: String?) {
        self.title = title
        self.imageName = imageName
        self.bussinessTitle = bussinessTitle
    }
}
