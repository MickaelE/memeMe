//
//  CustomTableViewCell.swift
//  MemeMe
//
//  Created by Mickael Eriksson on 2015-07-06.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import Foundation
import UIKit
class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var combinedText: UILabel!
    
    @IBOutlet weak var memeImage: UIImageView!
    
    //Custom Init
    func loadItem(#title: String, image: UIImage) {
        memeImage.image = image
        combinedText.text = title
    }
   }