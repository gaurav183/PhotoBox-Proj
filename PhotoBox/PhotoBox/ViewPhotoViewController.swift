//
//  ViewPhotoViewController.swift
//  PhotoBox
//
//  Created by Namrita Murali on 10/25/15.
//  Copyright © 2015 Namrita Murali. All rights reserved.
//

import UIKit
import Photos
import Parse

class ViewPhotoViewController: UIViewController {
    
    var assetCollection: PHAssetCollection!
    
    var photosAsset: PHFetchResult!
    
    var index: Int = 0
    
    
    @IBAction func buttonCancel(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func buttonExport(sender: AnyObject) {
    }
    
    @IBAction func buttonTrash(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {(alertAction) in
        //Delete Photo
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let request = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
                request!.removeAssets([self.photosAsset[self.index]])
                }, completionHandler: {(success, error) in
                    NSLog("\nDeleted Image -> %@", (success ? "Success" : "Error"))
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
                    if(self.photosAsset.count == 0) {
                        //no photos left
                        self.imageView.image = nil
                        print("No photos left!!")
                        return
                    }
                    
                    if (self.index >= self.photosAsset.count) {
                        self.index = self.photosAsset.count - 1
                    }
                    //reload the next image
                    self.displayPhoto()
                    

                })
            
        } ))
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {(alertAction) in alert.dismissViewControllerAnimated(true, completion: nil)}))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.hidesBarsOnTap = true
        self.displayPhoto()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayPhoto() {
        let imageManager = PHImageManager.defaultManager()
        
        _ = imageManager.requestImageForAsset(self.photosAsset[self.index] as! PHAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: nil, resultHandler: { (result, info) -> Void in
            self.imageView.image = result})
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
