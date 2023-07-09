//
//  PostsTableViewCell.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit

protocol PostsListTableViewCellDelegate: AnyObject {
    func deletePosts(cell: PostsListTableViewCell, index: IndexPath)
    func editPosts(cell: PostsListTableViewCell, index: IndexPath)
    func approvePosts(cell: PostsListTableViewCell, index: IndexPath)
    func postedPosts(cell: PostsListTableViewCell, index: IndexPath)
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
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var approveButton: UIButton!

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
        self.CreatedDate.text =  dateFormater?.serverToLocalforPost(date: userVM?.createdAt ?? String.blank) ?? "-"
        self.sheduledDate.text =  dateFormater?.serverToLocalforPost(date: userVM?.scheduledDate ?? String.blank) ?? "-"
        if userVM?.approved == true {
            self.approve.text = "YES"
            self.deleteButton.isHidden = true
            self.editButton.isHidden = true
            self.approveButton.setTitle("  Posted", for: .normal)
            self.approveButton.setTitleColor(UIColor.systemBlue, for: .normal)
            self.approveButton.setImage(UIImage(named: "postedImage"), for: .normal)
        }else{
            self.approve.text = "NO"
            self.deleteButton.isHidden = false
            self.editButton.isHidden = false
            self.approveButton.setTitle("Approve", for: .normal)
            self.approveButton.setTitleColor(UIColor.systemGreen, for: .normal)
            self.approveButton.setImage(UIImage(named: "approveImage"), for: .normal)
        }
        indexPath = index
    }
    
    func configureCellWithSearch(userVM: PostsListViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.postsFilterListDataAtIndex(index: index.row)
      
        self.id.text = String(userVM?.id ?? 0)
        self.post.text = userVM?.post ?? "-"
        self.hashtag.text = userVM?.hashtag ?? "-"
        let list: [String] = (userVM?.postLabels ?? []).map({$0.name ?? String.blank})
        self.postLabel.text = list.joined(separator: ", ")
        self.CreatedDate.text =  dateFormater?.serverToLocalforPost(date: userVM?.createdAt ?? String.blank) ?? "-"
        self.sheduledDate.text =  dateFormater?.serverToLocalforPost(date: userVM?.scheduledDate ?? String.blank) ?? "-"
        if userVM?.approved == true {
            self.approve.text = "YES"
            self.deleteButton.isHidden = true
            self.editButton.isHidden = true
            self.approveButton.setTitle("  Posted", for: .normal)
            self.approveButton.setTitleColor(UIColor.systemBlue, for: .normal)
            self.approveButton.setImage(UIImage(named: "postedImage"), for: .normal)
        }else{
            self.approve.text = "NO"
            self.deleteButton.isHidden = false
            self.editButton.isHidden = false
            self.approveButton.setTitle("Approve", for: .normal)
            self.approveButton.setTitleColor(UIColor.systemGreen, for: .normal)
            self.approveButton.setImage(UIImage(named: "approveImage"), for: .normal)
        }
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed(sender: UIButton) {
        self.delegate?.deletePosts(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed(sender: UIButton) {
        self.delegate?.editPosts(cell: self, index: indexPath)
    }
    
    @IBAction func approveButtonPressed(sender: UIButton) {
        if sender.titleLabel?.text == "Approve" {
            self.delegate?.approvePosts(cell: self, index: indexPath)
        }else{
            self.delegate?.postedPosts(cell: self, index: indexPath)

        }
    }
}
