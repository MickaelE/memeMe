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
    var singleMeme: UIImage!
    var textTest: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = singleMeme;
        if singleMeme == nil {
        println( "Detail: Single Meme is emty")
        }
         }

    
}
