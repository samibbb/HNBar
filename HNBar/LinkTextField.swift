//
//  LinkTextField.swift
//  HNBar
//
//  Created by James on 2015-07-25.
//  Copyright © 2015 James Hurst. All rights reserved.
//

import Cocoa

class LinkTextField: NSTextField {
    
    @IBInspectable var underlineColor: NSColor?
    
    // MARK: - Properties
    var url: NSURL?
    
    // MARK: Private
    private var trackingArea: NSTrackingArea?
    private var mouseInside = false {
        didSet { needsDisplay = true }
    }
    
    private var cachedHoverAttributedString: NSAttributedString?
    private var cachedAttributedString: NSAttributedString?
    
    // MARK: - Init
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addObservers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: - KVO
    private func addObservers() {
        addObserver(self, forKeyPath: "stringValue", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    private func removeObservers() {
        removeObserver(self, forKeyPath: "stringValue")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "stringValue" {
            cachedAttributedString = nil
            cachedHoverAttributedString = nil
        }
    }
    
    // MARK: - Mouse
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
    
    override func mouseDown(theEvent: NSEvent) {
        if stringValue.characters.count > 0 {
            if let url = url {
                NSWorkspace.sharedWorkspace().openURL(url)
            }
        }
    }
    
    // MARK: - Drawing
    private func getBaseAttributes() -> [String: AnyObject] {
        var baseAttributes: [String: AnyObject] = [:]
        
        if let underlineColor = underlineColor {
            baseAttributes[NSUnderlineColorAttributeName] = underlineColor
        }
    
        return baseAttributes
    }
    
    override func drawRect(dirtyRect: NSRect) {
        if stringValue.characters.count > 0 {
            if mouseInside && url != nil {
                if cachedHoverAttributedString == nil {
                    var attributes = getBaseAttributes()
                    attributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
                    cachedHoverAttributedString = NSAttributedString(string: stringValue, attributes: attributes)
                }
                
                attributedStringValue = cachedHoverAttributedString!
            } else {
                if cachedAttributedString == nil {
                    cachedAttributedString = NSAttributedString(string: stringValue, attributes: getBaseAttributes())
                }
                
                attributedStringValue = cachedAttributedString!
            }
        }
        
        super.drawRect(dirtyRect);
    }
    
}
