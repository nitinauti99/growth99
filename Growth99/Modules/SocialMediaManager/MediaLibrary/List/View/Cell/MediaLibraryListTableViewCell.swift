//
//  MediaLibraryTableViewCell.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit
import SDWebImage

protocol MediaLibraryListTableViewCellDelegate: AnyObject {
    func removeMediaLibrary(cell: MediaLibraryListTableViewCell, index: IndexPath)
    func editMediaLibrary(cell: MediaLibraryListTableViewCell, index: IndexPath)
}

class MediaLibraryListTableViewCell: UITableViewCell {
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var imageName: UIImageView!
    @IBOutlet private weak var fileName: UILabel!
    @IBOutlet private weak var tags: UILabel!
    @IBOutlet weak var subView: UIView!
    
    weak var delegate: MediaLibraryListTableViewCellDelegate?
    var dateFormater : DateFormaterProtocol?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateFormater = DateFormater()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCell(mediaLibraryListVM: MediaLibraryListViewModelProtocol?, index: IndexPath) {
        let mediaLibraryListVM = mediaLibraryListVM?.socialMediaLibrariesListDataAtIndex(index: index.row)
        self.fileName.text = mediaLibraryListVM?.filename
        self.id.text = String(mediaLibraryListVM?.id ?? 0)
        let libraryTag = (mediaLibraryListVM?.socialTags ?? []).map({$0.libraryTag}).map({$0?.name})
        self.tags.text = (libraryTag.map({$0 ?? ""})).joined(separator: ", ")
        self.imageName.sd_setImage(with: URL(string:mediaLibraryListVM?.location ?? ""), placeholderImage: UIImage(named: "Logo"), context: nil)
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeMediaLibrary(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editMediaLibrary(cell: self, index: indexPath)
    }
    
}
