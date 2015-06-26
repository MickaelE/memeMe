//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Mickael Eriksson on 2015-06-15.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController,   UICollectionViewDataSource, UICollectionViewDelegate {
    var memes: [memeObject]!
    let reuseIdentifier = "memeCollectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        self.collectionView?.reloadData()
        
    }
    
    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return memes.count;
    }
    @IBAction func openMemeEditor(sender: AnyObject) {
        //Open editor.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MemeEditorController") as! MemeEditorController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        println(memes.count)
        return memes.count;
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
        performSegueWithIdentifier("MemeDetailSegue1", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
        if (segue.identifier == "MemeDetailSegue1") {
            var viewController = segue.destinationViewController as! MemeDetailViewController
            viewController.singleMeme = memes[indexPath.row].memeImage;
        }
        }
        
    }

    
       
}