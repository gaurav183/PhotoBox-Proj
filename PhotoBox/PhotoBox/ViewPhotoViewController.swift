//
//  ViewPhotoViewController.swift
//  PhotoBox
//
//  Created by Namrita Murali on 10/25/15.
//  Copyright © 2015 Namrita Murali. All rights reserved.
//

import UIKit
import Photos

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
        print
("gets here")
        let imageManager = PHImageManager.defaultManager()
        
        var ID = imageManager.requestImageForAsset(self.photosAsset[self.index] as! PHAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: nil, resultHandler: { (result, info) -> Void in
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
