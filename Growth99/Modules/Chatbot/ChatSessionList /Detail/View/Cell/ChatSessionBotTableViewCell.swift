//
//  ChatSessionBotTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import UIKit

class ChatSessionBotTableViewCell: UITableViewCell {
    @IBOutlet private weak var message: UILabel!
    @IBOutlet private weak var subView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //self.subView.createBorderForView(redius: 8, width: 1)
        //self.subView.addBottomShadow(color: .gray)
    }

    func configureCell(chatSessionList: ChatSessionDetailViewModelProtocol?, index: IndexPath) {
        let chatSessionList = chatSessionList?.getChatSessionDetailDataAtIndex(index: index.row)
        let param = self.convertStringToDictionary(text: chatSessionList?.message ?? "")
        print(param?["message"] ?? "")
        if param == nil {
            self.message.attributedText = (chatSessionList?.message ?? "").htmlToAttributedString
        }else{
            guard let str = param?["message"] else {return}
            self.message.text = (str as! String).htmlToString
        }
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

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

