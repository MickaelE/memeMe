//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Mickael Eriksson on 2015-06-23.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController, UINavigationControllerDelegate  {
    
    @IBOutlet weak var memeImage: UIImageView!
    var textTest: String!
    var detailMeme: memeObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Load meme 
        if detailMeme == nil {
            println( "Detail:  Meme is emty")
        } else{
            memeImage.image = detailMeme.memeImage;
        }
         }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //the right seque?
        if (segue.identifier == "openEditFromDetailView") {
            //Open meme editor.
            var editController = segue.destinationViewController as! MemeEditorController
            editController.editMeme = detailMeme
           // editController.hidesBottomBarWhenPushed  = true;
        }
    }
    
    @IBAction func openMeneEditor(sender: AnyObject) {
         performSegueWithIdentifier("openEditFromDetailView", sender: self)
    }
}

