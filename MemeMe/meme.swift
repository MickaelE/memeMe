//
//  meme.swift
//  MemeMe
//
//  Created by Mickael Eriksson on 2015-06-12.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import Foundation
import UIKit

struct memeObject {
    
    var topString: String?
    var bottomString: String?
    var orginalImage: UIImage?
    var memeImage: UIImage?
    
    init(_topString: String?, _bottomString: String?, _orginalImage: UIImage?, _memeImage: UIImage?) {
        topString = _topString
        bottomString = _bottomString
        orginalImage = _orginalImage
        memeImage = _memeImage
    }
}