//
//  HomeViewController.swift
//  DPPicFeed
//
//  Created by David Porter on 3/27/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        //This is override because we are overriding the superclass
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            let newPost = Post(image: image)
            CloudKit.shared.save(post: newPost, completion: { (success) in
                if success {
                    print("Saved Post successfully to CLoudKit")
                }
                else {
                    print("We did NOT Successfully save to CLoutKit...")
                }
            })
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        guard let image = self.imageView.image else {
            return
        }
        let alertController = UIAlertController(title: "Filter", message: "Please select a filter", preferredStyle: .alert)
        
        let blackAndWhiteAction = UIAlertAction(title: "Black and White", style: .default) { (action) in
            Filters.filter(name: .blackAndWhite, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
            Filters.filter(name: .vintage, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let makeDarkerAction = UIAlertAction(title: "Darker", style: .default) { (action) in
            Filters.filter(name: .makeDarker, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let monoChromeAction = UIAlertAction(title: "Monochrome", style: .default) { (action) in
            Filters.filter(name: .monoChrome, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let comicEffectAction = UIAlertAction(title: "Comic", style: .default) { (action) in
            Filters.filter(name: .comicEffect, image: image, completion: { (filteredImage) in
                self.imageView.image = filteredImage
            })
        }
        
        let resetAction = UIAlertAction(title: "Reset Image", style: .destructive) { (action) in
            self.imageView.image = Filters.orignalImage
            }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(blackAndWhiteAction)
        alertController.addAction(vintageAction)
        alertController.addAction(makeDarkerAction)
        alertController.addAction(monoChromeAction)
        alertController.addAction(comicEffectAction)
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
