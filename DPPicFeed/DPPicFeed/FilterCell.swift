//
//  FilterCellCollectionViewCell.swift
//  DPPicFeed
//
//  Created by David Porter on 3/30/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
