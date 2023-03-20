//
//  PostsTableViewCell.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit

protocol PostsListTableViewCellDelegate: AnyObject {
    func detailPosts(cell: PostsListTableViewCell, index: IndexPath)
}

class PostsListTableViewCell: UITableViewCell {

    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var post: UILabel!
    @IBOutlet private weak var hashtag: UILabel!
    @IBOutlet private weak var postLabel: UILabel!
    @IBOutlet private weak var approve: UILabel!
    @IBOutlet private weak var sheduledDate: UILabel!
    @IBOutlet private weak var CreatedDate: UILabel!
    @IBOutlet private weak var subView: UIView!

    var dateFormater : DateFormaterProtocol?
    var buttonAddTimeTapCallback: () -> ()  = { }
    weak var delegate: PostsListTableViewCellDelegate?

    var indexPath = IndexPath()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        self.dateFormater = DateFormater()
    }

    func configureCell(userVM: PostsListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.postsListDataAtIndex(index: index.row)
      
        self.id.text = String(userVM?.id ?? 0)
        self.post.text = userVM?.post ?? "-"
        self.hashtag.text = userVM?.hashtag ?? "-"
        let list: [String] = (userVM?.postLabels ?? []).map({$0.name ?? String.blank})
        self.postLabel.text = list.joined(separator: ", ")
        self.approve.text = String(userVM?.approved ?? false)
        self.CreatedDate.text =  dateFormater?.serverToLocal(date: userVM?.createdAt ?? String.blank) ?? "-"
        self.sheduledDate.text =  dateFormater?.serverToLocal(date: userVM?.scheduledDate ?? String.blank) ?? "-"
        indexPath = index
    }
    
    @IBAction func detailButtonPressed() {
        self.delegate?.detailPosts(cell: self, index: indexPath)
    }
}
