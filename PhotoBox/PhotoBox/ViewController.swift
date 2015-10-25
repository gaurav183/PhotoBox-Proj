//
//  ViewController.swift
//  PhotoBox
//
//  Created by Namrita Murali on 10/25/15.
//  Copyright © 2015 Namrita Murali. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "PhotoCell"
let albumName = "PhotoBox"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    var albumFound: Bool = false
    
    var assetCollection: PHAssetCollection!
    
    var photosAsset: PHFetchResult!

//Actions and Outlets

    @IBAction func buttonCamera(sender: AnyObject) {
    }
   
    @IBAction func buttonPhotoAlbum(sender: AnyObject) {
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.whiteColor()
        
        //Check if folder exists, and if it doesn't create it
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@",albumName)
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if (collection.firstObject != nil) {
            //found the album
            self.albumFound = true;
            self.assetCollection = collection.firstObject as! PHAssetCollection
            
        }
        else {
            //create the folder
            NSLog("\nFolder \"%@\" does not exist\n Creating now...",albumName)
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(albumName)

                }, completionHandler: { (success, error) -> Void in
                    NSLog("Creation of Folder --> %@", (success ? "Success":"Error!"))
                    self.albumFound = (success ? true:false)
            })
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        //fetch the photos from collection
        self.navigationController!.hidesBarsOnTap = false
        if (self.assetCollection != nil) {
            self.photosAsset = PHAsset.fetchAssetsInAssetCollection((self.assetCollection)!, options: nil)

        }
        
        //Handle no photos in asset collection
        //Have a label that says no photos
        
        
        self.collectionView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier as String! == "viewLargePhoto") {
            let controller:ViewPhotoViewController = segue.destinationViewController as! ViewPhotoViewController
            let indexPath: NSIndexPath = self.collectionView.indexPathForCell(sender as! UICollectionViewCell)!
            
            controller.index = indexPath.item
            
            controller.photosAsset = self.photosAsset
            controller.assetCollection = self.assetCollection
            
        }
    }
    

//UICollectionViewDataSource Methods

    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        var count:Int = 0
        
        if (self.photosAsset != nil) {
            count = self.photosAsset.count
            
        }
        
        return count
    }

    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell: PhotoThumbnailCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoThumbnailCollectionViewCell
        
        
        let asset : PHAsset = self.photosAsset[indexPath.item] as! PHAsset
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: nil) { (result, info) -> Void in
            cell.setThumbnailImage(result!)
        }
    
        return cell
    }

}

