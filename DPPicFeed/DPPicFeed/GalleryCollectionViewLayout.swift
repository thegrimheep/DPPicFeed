//
//  GalleryCollectionViewLayout.swift
//  DPPicFeed
//
//  Created by David Porter on 3/29/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

import UIKit



class GalleryCollectionViewLayout: UICollectionViewFlowLayout {
    var columns = 2 //THis is the number of items across
    let spacing: CGFloat = 1.0 //this this space between items
    var screenWidth : CGFloat {
        return UIScreen.main.bounds.width
    }
    var itemWidth : CGFloat {
        let availableScreen = screenWidth - (CGFloat(self.columns) * self.spacing)
        return availableScreen / CGFloat(self.columns)
    }
    init(columns : Int = 2) {
        self.columns = columns
        super.init()
        self.minimumLineSpacing = spacing
        self.minimumInteritemSpacing = spacing
        self.itemSize = CGSize(width: itemWidth, height: itemWidth) //setting both of these to spacing makes them equal on the side and top and bottom.
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
