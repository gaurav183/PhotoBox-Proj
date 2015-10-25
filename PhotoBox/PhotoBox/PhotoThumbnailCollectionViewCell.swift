//
//  PhotoThumbnailCollectionViewCell.swift
//  PhotoBox
//
//  Created by Namrita Murali on 10/25/15.
//  Copyright © 2015 Namrita Murali. All rights reserved.
//

import UIKit

class PhotoThumbnailCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    func setThumbnailImage(thumbnailImage:UIImage) {
        self.imageView.image = thumbnailImage
    }
    
}
