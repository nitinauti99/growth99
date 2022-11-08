//
//  DrawerViewModel.swift
//  Growth99
//
//  Created by nitin auti on 06/11/22.
//

import Foundation

protocol DrawerViewModelProtocol {
    func loadJson() -> [menuList]
}

class DrawerViewModel: DrawerViewModelProtocol {
    
    var delegate: DrawerViewContollerProtocol?
    
    init(delegate: DrawerViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    func loadJson() -> [menuList] {
        if let path = Bundle.main.path(forResource: "test", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MenuModel.self, from: data)
                return jsonData.menuList
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }    
    
}
