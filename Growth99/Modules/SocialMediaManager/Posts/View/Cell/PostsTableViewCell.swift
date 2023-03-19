//
//  PostsTableViewCell.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit

protocol PostsListTableViewCellDelegate: AnyObject {
    func editPosts(cell: PostsListTableViewCell, index: IndexPath)
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
        dateFormater = DateFormater()
    }

    func configureCell(userVM: PostsListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.pateintDataAtIndex(index: index.row)
        self.id.text = String(userVM?.id ?? 0)
        self.post.text = userVM?.post
        self.hashtag.text = userVM?.hashtag
        self.postLabel.text = (userVM?.postLabels ?? []).
        self.approve.text = userVM?.approved
        self.CreatedDate.text =  dateFormater?.serverToLocal(date: userVM?.createdAt ?? String.blank)
        self.sheduledDate.text =  dateFormater?.serverToLocal(date: userVM?.scheduledDate ?? String.blank)
        
        indexPath = index
    }

    func configureCellWithSearch(userVM: PostsListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.pateintFilterDataAtIndex(index: index.row)
        self.firstName.text = userVM?.firstName
        self.lastName.text = userVM?.lastName
        self.id.text = String(userVM?.id ?? 0)
        self.email.text = userVM?.email
        self.createdDate.text =  dateFormater?.serverToLocal(date: userVM?.createdAt ?? String.blank)
        self.updatedDate.text =  dateFormater?.serverToLocal(date: userVM?.updatedAt ?? String.blank)
        self.createdBy.text = userVM?.createdBy
        self.updatedBy.text = userVM?.updatedBy
        let movement = userVM?.patientStatus
        pateintStatusLbi.text = userVM?.patientStatus
        pateintStatusImage.image = UIImage(named: movement?.lowercased() ?? String.blank)
        indexPath = index
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editPosts(cell: self, index: indexPath)
    }
    
    @IBAction func detailButtonPressed() {
        self.delegate?.detailPosts(cell: self, index: indexPath)
    }
}
