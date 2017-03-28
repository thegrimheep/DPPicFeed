//
//  Filters.swift
//  DPPicFeed
//
//  Created by David Porter on 3/28/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

import UIKit

enum FilterName : String {
    case vintage = "CIPhotoEffectTransfer"
    case blackAndWhite = "CIPhotoEffectMono"
    
    //add 3 more filters here
}

typealias FilterCompletion = (UIImage?) -> ()

class Filters {
    static var orignalImage = UIImage()
    //Access this by calling Filters.originalImage
}
