//
//  HackerNewsStoryCell.swift
//  HNBar
//
//  Created by James on 2015-07-22.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class HackerNewsStoryCell: NSView {
    
    @IBOutlet private var titleLabel: NSTextField!
    @IBOutlet private var hostnameLabel: NSTextField!
    @IBOutlet private var bylineLabel: NSTextField!
    
    func populate(story: Story) {
        titleLabel.stringValue = story.title
        hostnameLabel.stringValue = story.url.host ?? ""
        
        if (story.type == "job") {
            bylineLabel.stringValue = ""
        } else {
            
            var bylineText = "\(story.score) points by \(story.author)"
            if let commentCount = story.commentCount {
                bylineText +=  " · \(commentCount) comments"
            }
            bylineLabel.stringValue = bylineText
        }
    }
    
}
