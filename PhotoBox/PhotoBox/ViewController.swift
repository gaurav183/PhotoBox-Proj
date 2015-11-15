//
//  ViewController.swift
//  PhotoBox
//
//  Created by Namrita Murali on 10/25/15.
//  Copyright © 2015 Namrita Murali. All rights reserved.
//

import UIKit
import Photos
import Parse

let reuseIdentifier = "PhotoCell"
let albumName = "PhotoBox"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var albumFound: Bool = false
    
    var currentUser = PFUser.currentUser()
    
    var assetCollection: PHAssetCollection!
    
    var photosAsset: PHFetchResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.whiteColor()
        
        PFUser.logOut()
        
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
                _ = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(albumName)
                
                }, completionHandler: { (success, error) -> Void in
                    NSLog("Creation of Folder --> %@", (success ? "Success":"Error!"))
                    self.albumFound = (success ? true:false)
            })
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser()?.objectId == nil){
            self.performSegueWithIdentifier("showLogInScreen", sender: self)
        } else {
            
        }
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

//Actions and Outlets

    @IBAction func returnToStepZero(segue: UIStoryboardSegue) {
    }
    
    @IBAction func buttonCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            //load the camera interface
            let picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        }
            
        //no camera is available

        else {
            let alert = UIAlertController(title: "Error", message: "No camera available", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {(alertAction) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
   
    @IBAction func buttonPhotoAlbum(sender: AnyObject) {
            let picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    
    
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
    
//UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }

//UIImagePickerControllerDelegateMethods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset)
            albumChangeRequest!.addAssets([assetPlaceholder!])
            }, completionHandler: {(success, error) in
                NSLog("Adding Image to Library -> %@", (success ? "Success":"Error!"))
                picker.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func LoginButton(sender: AnyObject) {

    }

}

