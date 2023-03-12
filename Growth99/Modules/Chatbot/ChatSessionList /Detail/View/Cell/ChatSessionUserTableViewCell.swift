//
//  ChatSessionUserTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import UIKit

class ChatSessionUserTableViewCell: UITableViewCell {
    @IBOutlet private weak var message: UILabel!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var chatUserImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.chatUserImage.setImageColor(color: UIColor(hexString: "009EDE"))
    }

    func configureCell(chatSessionList: ChatSessionDetailViewModelProtocol?, index: IndexPath) {
        let chatSessionList = chatSessionList?.getChatSessionDetailDataAtIndex(index: index.row)
        self.message.text = chatSessionList?.message ?? ""
       // let param = self.convertStringToDictionary(text: chatSessionList?.message ?? "")
        
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
