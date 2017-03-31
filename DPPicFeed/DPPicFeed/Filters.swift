//
//  Filters.swift
//  DPPicFeed
//
//  Created by David Porter on 3/28/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

import UIKit

class Filter {
    static let shared = Filter()
    var context = CIContext()
    
    //This is the GPU Context, this is a singleton. There is only a single instance
    private init() {
        let options = [kCIContextOutputColorSpace : NSNull()]
        let eAGLContext = EAGLContext(api: .openGLES2)
        self.context = CIContext(eaglContext: (eAGLContext)!, options: options)
    }
}

    enum FilterName : String {
        case vintage = "CIPhotoEffectTransfer"
        case blackAndWhite = "CIPhotoEffectMono"
        case makeDarker = "CIColorPolynomial"
        case monoChrome = "CIColorMonochrome"
        case comicEffect = "CIColorPosterize"
        //add 3 more filters here
    }
typealias FilterCompletion = (UIImage?) -> ()

    
//    static let shared
    class Filters {
        static var orignalImage : UIImage?
    //Access this by calling Filters.originalImage
    class func filter(name: FilterName, image: UIImage, completion: @escaping FilterCompletion) {
        
        
        OperationQueue().addOperation {
            guard let filter = CIFilter(name: name.rawValue) else {
                fatalError("Failed to create CIFileter")
            }
            let coreImage = CIImage(image: image)
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            
            //Get the final Image for the GPU
            guard let outputImage = filter.outputImage else {
                fatalError("Failed to get output image from filter")
            }
            if let cgImage = Filter.shared.context.createCGImage(outputImage, from: outputImage.extent) {
                let orientation = image.imageOrientation
                let scale = image.scale
                
                let finalImage = UIImage(cgImage: cgImage, scale: scale, orientation: orientation)
                OperationQueue.main.addOperation {
                    completion(finalImage)
                }
                
            } else {
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
        }
    }
}
