//
//  GalleryViewController.swift
//  DPPicFeed
//
//  Created by David Porter on 3/29/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

import UIKit

protocol GalleryViewControllerDelegate : class {
    func galleryController(didSelect image : UIImage)
}

class GalleryViewController: UIViewController {
    
    weak var delegate : GalleryViewControllerDelegate?

    @IBOutlet weak var collectionView: UICollectionView!
    
    var allPosts = [Post]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.collectionViewLayout = GalleryCollectionViewLayout(columns: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }
    
    func update() {
        CloudKit.shared.getPosts { (posts) in
            if let posts = posts {
                self.allPosts = posts
            }
        }
    }

}

//MARK: UICollectionViewDataSource Extension

extension GalleryViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier, for: indexPath) as! GalleryCell
        
        cell.post = self.allPosts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else {
            return
        }
        let selectedPost = self.allPosts[indexPath.row]
        delegate.galleryController(didSelect: selectedPost.image)
    }
}
