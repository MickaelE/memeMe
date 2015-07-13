//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Mickael Eriksson on 2015-06-15.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController,   UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    var memes: [memeObject]!
    var longPressTarget: [NSIndexPath]?
    let reuseIdentifier = "memeCollectionCell"
    @IBOutlet var tableCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        
        //Get memes object
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        self.collectionView?.reloadData()
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return memes.count;
    }
    
    @IBAction func openMemeEditor(sender: AnyObject) {
        //Open editor.
        performSegueWithIdentifier("openEditorFromCollection", sender: self)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        println(memes.count)
        return 1;
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier,
        forIndexPath: indexPath) as! MemeCollectionViewCell
        
        // Configure the cell
        let image = memes[indexPath.row].memeImage
        cell.memeImage.image = image;
        return cell
    
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
         longPressTarget?.append(indexPath)
        performSegueWithIdentifier("MemeDetailSegue1", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        //If it's the editor segue that is called.
         if(segue.identifier == "openEditorFromCollection"){
            var editController = segue.destinationViewController as! MemeEditorController
            editController.hidesBottomBarWhenPushed  = true;
         } else {
        // Else if a valid cell is selected for show.
        if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
            //The detail segue is called
            if (segue.identifier == "MemeDetailSegue1") {
                var viewController = segue.destinationViewController as! MemeDetailViewController
                viewController.detailMeme = memes[indexPath.row]
                viewController.hidesBottomBarWhenPushed  = true;
            }
            }
        }
    }
}