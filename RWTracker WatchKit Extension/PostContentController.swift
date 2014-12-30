//
//  PostContentController.swift
//  RWTracker
//
//  Created by Nathan Cope on 12/29/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import WatchKit

class PostContentController: WKInterfaceController{
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var contentLabel: WKInterfaceLabel!
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let post = context as? [String: String]{
            titleLabel.setText(post["title"])
            contentLabel.setText(post["content"])
        }
    }
    
}
