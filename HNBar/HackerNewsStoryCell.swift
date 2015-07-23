//
//  HackerNewsStoryCell.swift
//  HNBar
//
//  Created by James on 2015-07-22.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class HackerNewsStoryCell: NSView {
    
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
    
    // MARK: - Setup
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
        mouseInside = true
    }
    
    override func mouseExited(theEvent: NSEvent) {
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
