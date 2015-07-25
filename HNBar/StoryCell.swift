//
//  StoryCell.swift
//  HNBar
//
//  Created by James on 2015-07-22.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class StoryCell: NSView {
    
    static var reuseIdentifier: String {
        return "StoryCell"
    }
    
    static var nibName: String {
       return "StoryCell"
    }
    
    static var nibBundle: NSBundle {
        return NSBundle.mainBundle()
    }
    
    // MARK: - Properties
    var hoverBackgroundColor = NSColor(calibratedWhite: 0.94, alpha: 1) {
        didSet { needsDisplay = true }
    }
    
    // MARK: Private
    private var trackingArea: NSTrackingArea?
    private var mouseInside = false {
        didSet { needsDisplay = true }
    }
    
    @IBOutlet private var titleLabel: NSTextField!
    @IBOutlet private var hostnameLabel: NSTextField!
    @IBOutlet private var bylineLabel: NSTextField!
    @IBOutlet private var commentLinkLabel: LinkTextField!
    
    // MARK: - Setup
    func populate(story: Story) {
        titleLabel.stringValue = story.title
        hostnameLabel.stringValue = story.url.host ?? ""
        commentLinkLabel.url = story.commentUrl
        
        if (story.type == "job") {
            bylineLabel.stringValue = ""
            commentLinkLabel.stringValue = ""
        } else {
            var bylineText = "\(story.score) points by \(story.author)"
            var commentLinkText = ""
            if let commentCount = story.commentCount {
                bylineText +=  " · "
                commentLinkText = "\(commentCount) comments"
            }
            bylineLabel.stringValue = bylineText
            commentLinkLabel.stringValue = commentLinkText
        }
    }
    
    // MARK: - Drawing
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        mouseInside = false
        
        if trackingArea == nil {
            trackingArea = NSTrackingArea(rect: NSZeroRect, options: NSTrackingAreaOptions.InVisibleRect.union(NSTrackingAreaOptions.ActiveAlways).union(NSTrackingAreaOptions.MouseEnteredAndExited), owner: self, userInfo: nil)
            addTrackingArea(trackingArea!)
        }
    }
    
    override func mouseEntered(theEvent: NSEvent) {
        super.mouseEntered(theEvent)
        mouseInside = true
    }
    
    override func mouseExited(theEvent: NSEvent) {
        super.mouseExited(theEvent)
        mouseInside = false
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if mouseInside {
            hoverBackgroundColor.setFill()
        } else {
            NSColor.clearColor().setFill()
        }
        
        var contentRect = bounds
        contentRect.size.height -= 1
        contentRect.origin.y += 1
        NSRectFill(contentRect)
    }
    
}
