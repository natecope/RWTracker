//
//  PostDetailsController.swift
//  RWTracker
//
//  Created by Nathan Cope on 12/29/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import WatchKit

class PostDetailsController: WKInterfaceController{
    
    
    @IBOutlet weak var categoryImage: WKInterfaceImage!
    
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    
    @IBOutlet weak var urlLabel: WKInterfaceLabel!
    
    @IBOutlet weak var categoryLabel: WKInterfaceLabel!
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
    var post: Post!
    
    lazy var dateFormatter: NSDateFormatter = {
        let dateFmt = NSDateFormatter()
        dateFmt.dateStyle = .MediumStyle
        dateFmt.timeStyle = .NoStyle
        return dateFmt
        
    }()


    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let post = context as? Post {
            self.post = post
        }
        
        if post.category == "Podcast Episodes" {
            addMenuItemWithItemIcon(.Accept, title: "Mark as Played", action: "markAsRead")
            addMenuItemWithItemIcon(.Play, title: "Play", action: "play")
        } else {
            addMenuItemWithItemIcon(.Accept, title: "Mark as Read", action: "markAsRead")
        }
        // Configure interface objects here.
        NSLog("%@ awakeWithContext", self)
    }

    override func willActivate(){
        
        super.willActivate()
        
        if post == nil {
            return
        }
        
        if post.category == "Announcements" {
            categoryImage.setImageNamed("announcement")
        } else if post.category == "Podcast Episodes" {
            categoryImage.setImageNamed("podcast")
        } else if post.category == "Video Tutorials"{
            categoryImage.setImageNamed("video")
        } else {
            categoryImage.setImageNamed("written")
        }
        
        categoryLabel.setText(post.category)
        titleLabel.setText(post.title)
        dateLabel.setText(dateFormatter.stringFromDate(post.timestamp))
        urlLabel.setText(post.link)
    }
    
    func markAsRead(){
        popController()
    }
    
    func play(){
        NSLog("I wish we could play audio! :(")
    }

}


