//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Mickael Eriksson on 2015-06-23.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController, UINavigationControllerDelegate {
     var meme: memeObject!
    
    @IBOutlet weak var memeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = meme.memeImage
    }

    
}
