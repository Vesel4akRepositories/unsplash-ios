//
//  ImagesListCell.swift
//  unsplash_practice
//
//  Created by Денис Петров on 09.06.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet private var bgImage: UIImageView!
    @IBOutlet private var likeIcon: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    
    func setBgImage(imageName: String){
        bgImage.image = UIImage(named: imageName)
    }
    
    func setLikeIcon(isLiked: Bool) {
        likeIcon.image = UIImage(named: isLiked ? "like_active" : "no_like")
    }
    
    func setDate(dateString: String){
        dateLabel.text = dateString
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
    }
}
