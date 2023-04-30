//
//  PostImageListTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 25/03/23.
//

import UIKit
import SDWebImage


class PostImageListTableViewCell: UITableViewCell {
    @IBOutlet private weak var createBy: UILabel!
    @IBOutlet private weak var imageName: UIImageView!
    @IBOutlet private weak var fileName: UILabel!
    @IBOutlet private weak var tags: UILabel!
    @IBOutlet private weak var createdAt: UILabel!

    @IBOutlet weak var subView: UIView!
    
    var dateFormater : DateFormaterProtocol?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateFormater = DateFormater()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCell(mediaLibraryListVM: PostImageListViewModel?, index: IndexPath) {
        let mediaLibraryListVM = mediaLibraryListVM?.getSocialPostImageListDataAtIndex(index: index.row)
        self.fileName.text = mediaLibraryListVM?.filename
        self.createBy.text = "By" + (mediaLibraryListVM?.createdBy?.firstName ?? "")
        let libraryTag = (mediaLibraryListVM?.socialTags ?? []).map({$0.libraryTag}).map({$0?.name})
        self.tags.text = (libraryTag.map({$0 ?? ""})).joined(separator: ", ")
        self.imageName.sd_setImage(with: URL(string:mediaLibraryListVM?.location ?? ""), placeholderImage: UIImage(named: "logo"), context: nil)
        self.createdAt.text =  "On" + (self.dateFormater?.serverToLocal(date: (mediaLibraryListVM?.createdAt) ?? "") ?? "")

        indexPath = index
    }

}
