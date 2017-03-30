//
//  HomeViewController.swift
//  DPPicFeed
//
//  Created by David Porter on 3/27/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

import UIKit
import Social

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let filterNames = [FilterName.vintage, FilterName.blackAndWhite, FilterName.comicEffect, FilterName.makeDarker, FilterName.monoChrome]
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var CollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        //This is override because we are overriding the superclass
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.dataSource = self
    }
    
    func setupGalleryDelegate() {
        if let tabBarController = self.tabBarController {
            guard let viewControllers = tabBarController.viewControllers else {
                return
            }
            guard let gallerController = viewControllers[1] as? GalleryViewController else {
                return
            }
            gallerController.delegate = self
            setupGalleryDelegate()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        filterButtonTopConstraint.constant = 8
        
        UIView.animate(withDuration: 1.0) {
        self.view.layoutIfNeeded()
        }
        
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.present(self.imagePicker, animated: true, completion: nil)
        //this is for the imagePickerController, see docs for options
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        //this allows funcionality to dismiss the imageview.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            Filters.orignalImage = originalImage
            self.collectionView.reloadData()
            self.imageView.image = originalImage
            print(originalImage.imageOrientation)//added print statement
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        print("User Tapped Image")
        self.presentActionSheet()
        //this is basically an event listener.
    }
   
    @IBAction func postButtonPressed(_ sender: Any) {
        if let image = self.imageView.image {
            let newPost = Post(image: image, creationDate: nil)
            CloudKit.shared.save(post: newPost, completion: { (success) in
                if success {
                    print("Saved Post successfully to CloudKit")
                }
                else {
                    print("We did NOT Successfully save to CloutKit...")
                }
            })
        }
    }
    @IBAction func userLongPressed(_ sender: UILongPressGestureRecognizer) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            guard let composeController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else {
                return
            }
            composeController.add(self.imageView.image)
            self.present(composeController, animated: true, completion: nil)
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        guard let image = self.imageView.image else {
            return
        }
        self.CollectionViewHeightConstraint.constant = 150
        
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
        
        
        
        
//        let alertController = UIAlertController(title: "Filter", message: "Please select a filter", preferredStyle: .alert)
//        
//        let blackAndWhiteAction = UIAlertAction(title: "Black and White", style: .default) { (action) in
//            Filters.filter(name: .blackAndWhite, image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
//            Filters.filter(name: .vintage, image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let makeDarkerAction = UIAlertAction(title: "Darker", style: .default) { (action) in
//            Filters.filter(name: .makeDarker, image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let monoChromeAction = UIAlertAction(title: "Monochrome", style: .default) { (action) in
//            Filters.filter(name: .monoChrome, image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let comicEffectAction = UIAlertAction(title: "Comic", style: .default) { (action) in
//            Filters.filter(name: .comicEffect, image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let resetAction = UIAlertAction(title: "Reset Image", style: .destructive) { (action) in
//            self.imageView.image = Filters.orignalImage
//            }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        alertController.addAction(blackAndWhiteAction)
//        alertController.addAction(vintageAction)
//        alertController.addAction(makeDarkerAction)
//        alertController.addAction(monoChromeAction)
//        alertController.addAction(comicEffectAction)
//        alertController.addAction(resetAction)
//        alertController.addAction(cancelAction)
//        
//        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentActionSheet() {
        let actionSheetController = UIAlertController(title: "Source", message: "Please Select Source Type", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .camera)
        }
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAction.isEnabled = false
        }
        
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell
        
        guard let originalImage = Filters.orignalImage else {
            return filterCell
        }
        guard let resizedImage = originalImage.resize(size: CGSize(width: 150, height: 150)) else {
            return filterCell
        }
        let filterName = self.filterNames[indexPath.row]
        
        Filters.filter(name: filterName, image: originalImage) { (filteredImage) in
            filterCell.imageView.image = filteredImage
        }
        return filterCell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
}

extension HomeViewController: GalleryViewControllerDelegate {
    func galleryController(didSelect image: UIImage) {
        self.imageView.image = image
        self.tabBarController?.selectedIndex = 0
        //this allows the selected photo in the gallery to take you back to the homeview.
        //This is passing information back to the view
    }
}
